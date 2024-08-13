//
//  ChatsViewModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.05.2024.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

@MainActor
class ChatsViewModel {
    
    let recentMessages = BehaviorSubject<[RecentMessageModel]>(value: [])
    
    private var authenticatedUserId : String {
        guard let userId = SCAuthenticationManager.shared.getAuthenticatedUser()?.uid else {
            return ""
        }
        
        return userId
    }
    
    private var listeners: [ListenerRegistration?] = []
    
    init() {
        fetchRecentMessages()
    }
    
    func fetchRecentMessages() {
        
        var messages = try? recentMessages.value()
        messages?.removeAll()
        self.recentMessages.onNext(messages ?? [])
        
        let recentMessagesListener = SCDatabaseManager.shared.addListener(
            collectionId: .mainRecentMessages,
            documentId: authenticatedUserId,
            secondCollectionId: DatabaseCollections.subRecentMessage.rawValue,
            data: MessageModel.self,
            query: { query in
                query.order(by: MessageModel.CodingKeys.messageDate.rawValue, descending: true)
            }
        ) { result in
            switch result {
            case .success(let data):
                if let newMessages = data as? [MessageModel] {
                    self.addNewRecentMessage(with: newMessages)
                }
            case .failure(let error):
                print("Failed to listen for messages in Chat View: \(error)")
            }
        }
        
        addListener(recentMessagesListener)
        
    }
    
    func deleteRecentMessage(with message : RecentMessageModel) {
        
        Task {
            
            do {
                
                removeAllListeners()
                
                var currentMessages = try self.recentMessages.value()
                if let index = currentMessages.firstIndex(where: { $0.recentMessageId == message.recentMessageId }) {
                    currentMessages.remove(at: index)
                    self.recentMessages.onNext(currentMessages)
                }
                
                try await SCDatabaseManager.shared.deleteSingleData(
                    collectionId: .mainRecentMessages,
                    documentId: authenticatedUserId,
                    secondCollectionId: DatabaseCollections.subRecentMessage.rawValue,
                    secondDocumentId: message.receiverProfile.id
                )
                
                try await SCDatabaseManager.shared.deleteMultipleData(
                    collectionId: .messages,
                    documentId: authenticatedUserId,
                    secondCollectionId: message.receiverProfile.id
                )
                
                try await SCMediaStorageManager.shared.deleteMultipleData(
                    folderName: .messageMedia,
                    fileName: authenticatedUserId,
                    secondFileName: message.receiverProfile.id
                )
                
                fetchRecentMessages()
                
            }catch {
                print("Failed to delete recent message: \(error)")
            }
        }
        
    }
    
}

private extension ChatsViewModel {
    
    func addNewRecentMessage(with messages : [MessageModel]) {
        
        let userIds = messages.compactMap { message in
            message.receiverId == authenticatedUserId ? message.senderId : message.receiverId
        }
        
        guard !userIds.isEmpty else {return}
        
        let recentMessageReceiverListener = SCDatabaseManager.shared.addListener(
            collectionId: .users,
            data: FirebaseUserModel.self,
            query: { query in
                query.whereField(FieldPath.documentID(), in: userIds)
            },
            completion: { result in
                switch result {
                case .success(let data):
                    guard let firebaseUsers = data as? [FirebaseUserModel] else { return }
                    let chatMessages = self.createRecentMessage(from: messages, with: firebaseUsers)
                    self.updateRecentMessages(from: chatMessages)
                case .failure(let error):
                    print("Failed to retrieve users for recent messages: \(error)")
                }
            })
        
        addListener(recentMessageReceiverListener)
        
    }
    
    func createRecentMessage(from messages : [MessageModel], with users : [FirebaseUserModel]) -> [RecentMessageModel] {
        
        let contacts = users.compactMap { user in
            return ContactModel(from: user)
        }
        
        let chatMessages = messages.compactMap { message -> RecentMessageModel? in
            guard let contact = contacts.first(where: {$0.id == message.receiverId || $0.id == message.senderId}) else {
                print("No user found associated with this ID.")
                return nil
            }
            
            let recentMessage = RecentMessageModel(
                recentMessageId: message.messageId,
                receiverProfile: contact,
                recentMessageContent: message.messageContent,
                recentMessageType: message.messageType,
                recentMessageDate: message.messageDate
            )
            
            return recentMessage
        }
        
        return chatMessages
        
    }
    
    func updateRecentMessages(from chatMessages : [RecentMessageModel]) {
        
        do {
            
            var currentMessages = try self.recentMessages.value()
            
            currentMessages.removeAll { currentMessage in
                chatMessages.contains { chatMessage in
                    currentMessage.receiverProfile.id  == chatMessage.receiverProfile.id
                }
            }
            
            currentMessages.insert(contentsOf: chatMessages, at: 0)
            
            self.recentMessages.onNext(currentMessages)
            
        }catch {
            print("Failed to create recent users: \(error)")
        }
        
    }
    
    func addListener(_ listener: ListenerRegistration?) {
        listeners.append(listener)
    }
    
    func removeAllListeners() {
        listeners.forEach { $0?.remove() }
        listeners.removeAll()
    }
    
}
