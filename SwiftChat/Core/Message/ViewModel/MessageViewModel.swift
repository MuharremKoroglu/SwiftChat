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
    
    func sendMessage(textMessage : String? = nil, mediaMessage : Data? = nil) {
        
        var senderMessageContent : String = ""
        var receiverMessageContent : String = ""
        var messageType : MessageType = .text
        
        Task {
            do {
                
                if let text = textMessage {
                    senderMessageContent = text
                    receiverMessageContent = text
                }
                
                if let data = mediaMessage {
                    
                    let senderImageUrl = try await self.uploadMedia(
                        data: data,
                        senderId: authenticatedUserId,
                        receiverId: receiverUserId
                    )
                    
                    let receiverImageUrl = try await self.uploadMedia(
                        data: data,
                        senderId: receiverUserId,
                        receiverId: authenticatedUserId
                    )
                    
                    senderMessageContent = senderImageUrl.absoluteString
                    receiverMessageContent = receiverImageUrl.absoluteString
                    messageType = .media
                    
                }
                                
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
                    messageContent: receiverMessageContent,
                    messageDate: Date(),
                    messageType: messageType
                )
                
                try await self.saveMessage(
                    message: senderMessage,
                    senderId: authenticatedUserId,
                    receiverId: receiverUserId
                )
                
                try await self.saveMessage(
                    message: receiverMessage,
                    senderId: receiverUserId,
                    receiverId: authenticatedUserId
                )
                
                self.saveRecentMessage(with: senderMessage)
                
            } catch {
                print("Error occurred while saving the message: \(error)")
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
                print("Failed to listen for messages in Messages View: \(error)")
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
                print("Error occurred while saving the recent message: \(error)")
            }
            
        }
        
    }
    
    func uploadMedia(data: Data, senderId: String, receiverId: String) async throws -> URL {
        return try await SCMediaStorageManager.shared.uploadData(
            folderName: .messageMedia,
            fileName: senderId,
            secondFileName: receiverId,
            thirdFileName: UUID().uuidString,
            data: data
        )
    }

    func saveMessage(message: MessageModel, senderId: String, receiverId: String) async throws {
        try await SCDatabaseManager.shared.createData(
            collectionId: .messages,
            documentId: senderId,
            secondCollectionId: receiverId,
            data: message
        )
    }
}

