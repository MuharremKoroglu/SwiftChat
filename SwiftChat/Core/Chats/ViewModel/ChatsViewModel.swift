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
    
    init() {
        fetchRecentMessages()
    }
    
    
    func fetchRecentMessages() {
        
        guard let senderId = SCAuthenticationManager.shared.getAuthenticatedUser()?.uid else {
            return
        }
                
        SCDatabaseManager.shared.addListener(
            collectionId: .mainRecentMessages,
            documentId: senderId,
            secondCollectionId: DatabaseCollections.subRecentMessage.rawValue,
            data: MessageModel.self,
            query: MessageModel.CodingKeys.messageDate.rawValue) { result in
                switch result {
                case .success(let newMessages):
                    print("Firebase mesajları : \(newMessages)")
                    self.fetchUserData(with: newMessages)
                case .failure(let error):
                    print("Mesaj dinleme başarısız: \(error)")
                }
            }
    
    }
    
    
    private func fetchUserData(with messages : [MessageModel]) {
        
        Task {
            do {
                
                guard let authenticatedUserId = SCAuthenticationManager.shared.getAuthenticatedUser()?.uid else {
                    return
                }
                
                var userIds = messages.map { $0.receiverId }
                
                if let index = userIds.firstIndex(of: authenticatedUserId) {
                    userIds[index] = messages[index].senderId
                }
                
                print("KULLANICI IDLERİ : \(userIds)")
                                
                let users = try await SCDatabaseManager.shared.readMultipleData(
                    collectionId: .users,
                    query: userIds,
                    data: FirebaseUserModel.self
                )
                
                let chatMessages = messages.compactMap { message -> RecentMessageModel? in
                    guard let user = users.first(where: { $0.userId == message.receiverId || $0.userId == message.senderId}) else {
                        print("Bu id ile ilişkili kullanıcı bulunamadı.")
                        return nil
                    }
                    
                    return RecentMessageModel(
                        userProfileImage: user.profileImage,
                        userName: user.userName,
                        recentMessageContent: message.messageContent,
                        recentMessageType: message.messageType,
                        recentDate: message.messageDate
                    )
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
