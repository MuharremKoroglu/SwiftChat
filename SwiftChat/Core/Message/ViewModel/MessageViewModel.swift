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
    
    init(user: ContactModel) {
        self.user = user
        fetchMessages()
    }
    
    func sendMessage(message: String, messageType : MessageType) {
        Task {
            do {
                guard let senderId = SCAuthenticationManager.shared.getAuthenticatedUser()?.uid else {
                    return
                }
                
                let receiverId = user.id
                
                let message = MessageModel(
                    senderId: senderId,
                    receiverId: receiverId,
                    messageContent: message,
                    messageDate: Date(), 
                    messageType: messageType
                )
                
                try await SCDatabaseManager.shared.createData(
                    collectionId: .messages,
                    documentId: senderId,
                    secondCollectionId: receiverId,
                    data: message
                )
                
                try await SCDatabaseManager.shared.createData(
                    collectionId: .messages,
                    documentId: receiverId,
                    secondCollectionId: senderId,
                    data: message
                )
                
            } catch {
                print("Mesaj kaydında hata: \(error)")
            }
        }
    }
    
    func fetchMessages() {
        guard let senderId = SCAuthenticationManager.shared.getAuthenticatedUser()?.uid else {
            return
        }
        
        let receiverId = user.id
        
        SCDatabaseManager.shared.addListener(
            collectionId: .messages,
            documentId: senderId,
            secondCollectionId: receiverId,
            data: MessageModel.self, 
            query: MessageModel.CodingKeys.messageDate.rawValue) { result in
                switch result {
                case .success(let newMessages):
                    do {
                        var currentMessages = try self.messages.value()
                        currentMessages.append(contentsOf: newMessages)
                        self.messages.onNext(currentMessages)
                        guard let lastMessage = currentMessages.last else {return}
                        self.saveRecentMessage(with: lastMessage)
                    } catch {
                        print("Mesajları güncellemede hata: \(error)")
                    }
                case .failure(let error):
                    print("Mesaj dinleme başarısız: \(error)")
                }
            }
    }
    
    private func saveRecentMessage(with message : MessageModel) {
        
        Task {
            
            guard let senderId = SCAuthenticationManager.shared.getAuthenticatedUser()?.uid else {
                return
            }
            
            let receiverId = user.id
            
            do {
                
                try await SCDatabaseManager.shared.createData(
                    collectionId: .mainRecentMessages,
                    documentId: senderId,
                    secondCollectionId: DatabaseCollections.subRecentMessage.rawValue,
                    secondDocumentId: receiverId,
                    data: message
                )
                
                try await SCDatabaseManager.shared.createData(
                    collectionId: .mainRecentMessages,
                    documentId: receiverId,
                    secondCollectionId: DatabaseCollections.subRecentMessage.rawValue,
                    secondDocumentId: senderId,
                    data: message
                )
                
            }catch {
                print("Son mesaj kaydı yapılamadı : \(error)")
            }
            
        }
        
    }
}

