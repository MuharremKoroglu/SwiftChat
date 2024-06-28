//
//  MessageViewModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.06.2024.
//

import Foundation
import RxSwift
import RxCocoa

class MessageViewModel {
    
    
    
    func sendMessage(user : ContactModel, message : String) {
        
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
                    messageDate: Date()
                )
                
                try await SCDatabaseManager.shared.createData(
                    collectionId: .messages,
                    documentId: senderId,
                    secondDocumentId: receiverId,
                    data: message
                )
                
            }catch {
                print("Mesaj kaydında hata : \(error)")
            }

        }

    }
    
    
    
    
    
    
}
