//
//  ChatsViewModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.05.2024.
//

import Foundation
import RxSwift
import RxCocoa

@MainActor
class ChatsViewModel {
    
    let recentMessages = BehaviorSubject<[RecentMessageModel]>(value: [])
    
    private var authenticatedUserId : String {
        guard let userId = SCAuthenticationManager.shared.getAuthenticatedUser()?.uid else {
            return ""
        }
        
        return userId
    }
    
    init() {
        fetchRecentMessages()
    }
    
    
    func fetchRecentMessages() {
                
        SCDatabaseManager.shared.addListener(
            collectionId: .mainRecentMessages,
            documentId: authenticatedUserId,
            secondCollectionId: DatabaseCollections.subRecentMessage.rawValue,
            data: MessageModel.self,
            query: MessageModel.CodingKeys.messageDate.rawValue) { result in
                switch result {
                case .success(let newMessages):
                    self.fetchUserData(with: newMessages)
                case .failure(let error):
                    print("Mesaj dinleme başarısız: \(error)")
                }
            }
    
    }

    func deleteRecentMessage(with message : RecentMessageModel) {
        
        Task {
            
            do {
                
                var recentMessages = try recentMessages.value()
                
                recentMessages.removeAll { $0.receiverProfile.id == message.receiverProfile.id }
                
                self.recentMessages.onNext(recentMessages)
                
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
                
            }catch {
                print("Son mesaj silinemedi : \(error)")
            }
 
        }
        
    }
    
    
    private func fetchUserData(with messages : [MessageModel]) {
        
        Task {
            do {
                
                guard let authenticatedUserId = SCAuthenticationManager.shared.getAuthenticatedUser()?.uid else {
                    return
                }
                
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
                currentMessages.append(contentsOf: chatMessages)
                self.recentMessages.onNext(currentMessages)

            }catch {
                print("Chat ekranında kullanıcı verileri alınamadı : \(error)")
            }
        }
 
    }
    
    
}
