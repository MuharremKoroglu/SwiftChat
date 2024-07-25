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
    
    private var listener : ListenerRegistration?
    
    init() {
        fetchRecentMessages()
    }
    
    
    func fetchRecentMessages() {
        
        listener = SCDatabaseManager.shared.addListener(
            collectionId: .mainRecentMessages,
            documentId: authenticatedUserId,
            secondCollectionId: DatabaseCollections.subRecentMessage.rawValue,
            data: MessageModel.self,
            query: MessageModel.CodingKeys.messageDate.rawValue) { result in
                switch result {
                case .success(let newMessages):
                    self.addNewRecentMessage(with: newMessages)
                case .failure(let error):
                    print("Mesaj dinleme başarısız: \(error)")
                }
            }
        
    }
    
    func deleteRecentMessage(with message : RecentMessageModel) {
                
        Task {
            
            do {
                
                removeListener()
                
                var currentMessages = try self.recentMessages.value()
                if let index = currentMessages.firstIndex(where: { $0.receiverProfile.id == message.receiverProfile.id }) {
                    currentMessages.remove(at: index)
                    self.recentMessages.onNext(currentMessages)
                }
                
                
                try await SCDatabaseManager.shared.deleteMultipleData(
                    collectionId: .messages,
                    documentId: authenticatedUserId,
                    secondCollectionId: message.receiverProfile.id
                )
                
                
                try await SCDatabaseManager.shared.deleteSingleData(
                    collectionId: .mainRecentMessages,
                    documentId: authenticatedUserId,
                    secondCollectionId: DatabaseCollections.subRecentMessage.rawValue,
                    secondDocumentId: message.receiverProfile.id
                )
                
                fetchRecentMessages()
                                                
            }catch {
                print("Son mesaj silinemedi : \(error)")
            }
        }
                
    }
    
}

private extension ChatsViewModel {
    
    func removeListener() {
        listener?.remove()
    }
    
    func addNewRecentMessage(with messages : [MessageModel]) {
        
        Task {
            do {
                
                let userIds = messages.compactMap { message in
                    message.receiverId == authenticatedUserId ? message.senderId : message.receiverId
                }
                
                let firebaseUsers = try await SCDatabaseManager.shared.readMultipleData(
                    collectionId: .users,
                    query: userIds,
                    data: FirebaseUserModel.self
                )
                
                let contacts = firebaseUsers.compactMap { user in
                    return ContactModel(from: user)
                }
                
                let chatMessages = messages.compactMap { message -> RecentMessageModel? in
                    guard let contact = contacts.first(where: {$0.id == message.receiverId || $0.id == message.senderId}) else {
                        print("Bu id ile ilişkili kullanıcı bulunamadı.")
                        return nil
                    }
                    
                    let recentMessage = RecentMessageModel(
                        receiverProfile: contact,
                        recentMessageContent: message.messageContent,
                        recentMessageType: message.messageType,
                        recentMessageDate: message.messageDate
                    )
                    
                    return recentMessage
                }
                
                var currentMessages = try self.recentMessages.value()
                let filteredMessages = chatMessages.filter { recentMessage in
                    !currentMessages.contains(where: {$0.receiverProfile.id == recentMessage.receiverProfile.id})
                }
                currentMessages.append(contentsOf: filteredMessages)
                self.recentMessages.onNext(currentMessages)

            }catch {
                print("Chat ekranında kullanıcı verileri alınamadı : \(error)")
            }
        }
 
    }
    
}
