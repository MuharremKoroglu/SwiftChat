//
//  MessageViewModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.06.2024.
//

import Foundation
import FirebaseFirestore
import RxSwift
import RxCocoa

@MainActor
class MessageViewModel {
    
    let messages = BehaviorSubject<[MessageModel]>(value: [])
    
    let user: ContactModel
    
    private var listener : ListenerRegistration?
    
    private var authenticatedUserId : String {
        guard let userId = SCAuthenticationManager.shared.getAuthenticatedUser()?.uid else {
            return ""
        }
        
        return userId
    }
    
    private var receiverUserId : String {
       return user.id
    }
    
    init(user: ContactModel) {
        self.user = user
        fetchMessages()
    }
    
    func sendMessage(senderMessageContent: String, receiverMessageContent : String, messageType : MessageType) {
        Task {
            do {
                                
                let senderMessage = MessageModel(
                    messageId: UUID().uuidString,
                    senderId: authenticatedUserId,
                    receiverId: receiverUserId,
                    messageContent: senderMessageContent,
                    messageDate: Date(),
                    messageType: messageType
                )
                
                let receiverMessage = MessageModel(
                    messageId: UUID().uuidString,
                    senderId: authenticatedUserId,
                    receiverId: receiverUserId,
                    messageContent: senderMessageContent,
                    messageDate: Date(),
                    messageType: messageType
                )
                
                try await SCDatabaseManager.shared.createData(
                    collectionId: .messages,
                    documentId: authenticatedUserId,
                    secondCollectionId: receiverUserId,
                    data: senderMessage
                )
                
                try await SCDatabaseManager.shared.createData(
                    collectionId: .messages,
                    documentId: receiverUserId,
                    secondCollectionId: authenticatedUserId,
                    data: receiverMessage
                )
                
                self.saveRecentMessage(with: senderMessage)
                
            } catch {
                print("Mesaj kaydında hata: \(error)")
            }
        }
    }
    
    func fetchMessages() {
        
        var messages = try? messages.value()
        messages?.removeAll()
        self.messages.onNext(messages ?? [])
        
        listener = SCDatabaseManager.shared.addListener(
            collectionId: .messages,
            documentId: authenticatedUserId,
            secondCollectionId: receiverUserId,
            data: MessageModel.self,
            query: { query in
                query.order(by: MessageModel.CodingKeys.messageDate.rawValue)
            },
            documentChangeType: .added
        ) { result in
            switch result {
            case .success(let data):
                if let newMessages = data as? [MessageModel]{
                    do {
                        var currentMessages = try self.messages.value()
                        currentMessages.append(contentsOf: newMessages)
                        self.messages.onNext(currentMessages)
                    } catch {
                        print("Error updating messages: \(error)")
                    }
                }
            case .failure(let error):
                print("MessageView da Mesaj dinleme başarısız: \(error)")
            }
        }
    }
    
    func removeListener() {
        listener?.remove()
    }
}

private extension MessageViewModel {
    
    func saveRecentMessage(with message : MessageModel) {
        
        Task {
                                    
            do {
                            
                try await SCDatabaseManager.shared.createData(
                    collectionId: .mainRecentMessages,
                    documentId: authenticatedUserId,
                    secondCollectionId: DatabaseCollections.subRecentMessage.rawValue,
                    secondDocumentId: receiverUserId,
                    data: message
                )
                
                try await SCDatabaseManager.shared.createData(
                    collectionId: .mainRecentMessages,
                    documentId: receiverUserId,
                    secondCollectionId: DatabaseCollections.subRecentMessage.rawValue,
                    secondDocumentId: authenticatedUserId,
                    data: message
                )
                
            }catch {
                print("Son mesaj kaydı yapılamadı : \(error)")
            }
            
        }
        
    }
}

