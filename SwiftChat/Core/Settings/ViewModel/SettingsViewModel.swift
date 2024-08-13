//
//  SettingsViewModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 4.06.2024.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

@MainActor
class SettingsViewModel {
    
    let user = BehaviorSubject<ContactModel?>(value: nil)
    var isProcessing = PublishSubject<Bool>()
    var isCompleted = PublishSubject<Bool>()
    
    private var authenticatedUserId : String {
        guard let userId = SCAuthenticationManager.shared.getAuthenticatedUser()?.uid else {
            return ""
        }
        
        return userId
    }
    
    private var listener : ListenerRegistration?
    
    func fetchUserData() {
        
        isProcessing.onNext(true)
                
        listener = SCDatabaseManager.shared.addListener(
            collectionId: .users,
            documentId: authenticatedUserId,
            data: FirebaseUserModel.self,
            completion: { result in
                
                switch result {
                case .success(let data):
                    if let firebaseUser = data as? FirebaseUserModel {
                        let contactUser = ContactModel(from: firebaseUser)
                        self.user.onNext(contactUser)
                    }
                case .failure(let error):
                    print("Failed to listen for user in Settings View: \(error)")
                }
                
                self.isProcessing.onNext(false)
            })
        
    }
    
    func updateUserProfilePicture(with imageData : Data) {
        
        isProcessing.onNext(true)
        
        Task {
            
            let imageUrl = try await SCMediaStorageManager.shared.uploadData(
                folderName: .profilePictures,
                fileName: authenticatedUserId,
                data: imageData
            )
            
            try await SCDatabaseManager.shared.updateData(
                collectionId: .users,
                documentId: authenticatedUserId,
                field: FirebaseUserModel.CodingKeys.profileImage.rawValue,
                newValue: imageUrl.absoluteString
            )
            
            isProcessing.onNext(false)
            
        }
        
    }
    
    func deleteAccount(with userIds : [String]) {
        
        removeListener()
        isProcessing.onNext(true)
        
        Task {
            do {
                
                if !userIds.isEmpty {
                    
                    for id in userIds {
                        
                        try await SCDatabaseManager.shared.deleteMultipleData(
                            collectionId: .messages,
                            documentId: authenticatedUserId,
                            secondCollectionId: id
                        )
                        
                        try await SCMediaStorageManager.shared.deleteMultipleData(
                            folderName: .messageMedia,
                            fileName: authenticatedUserId,
                            secondFileName: id
                        )
                    }
                    
                }
                
                try await SCDatabaseManager.shared.deleteMultipleData(
                    collectionId: .mainRecentMessages,
                    documentId: authenticatedUserId,
                    secondCollectionId: DatabaseCollections.subRecentMessage.rawValue
                )
                
                try await SCDatabaseManager.shared.deleteSingleData(
                    collectionId: .users,
                    documentId: authenticatedUserId
                )
                
                try await SCMediaStorageManager.shared.deleteSingleData(
                    folderName: .profilePictures,
                    fileName: authenticatedUserId
                )
                
                try SCAuthenticationManager.shared.deleteAccount()
                
                isProcessing.onNext(false)
                isCompleted.onNext(true)
                
            }catch{
                isProcessing.onNext(false)
                isCompleted.onNext(false)
                print("Error occurred while deleting user account: \(error)")
            }
        }

    }
    
    func signOut() {
        
        removeListener()
        isProcessing.onNext(true)
        
        do {
            try SCAuthenticationManager.shared.signOut()
            
            isProcessing.onNext(false)
            isCompleted.onNext(true)
        }catch{
            isProcessing.onNext(false)
            isCompleted.onNext(false)
            print("Sign-out failed: \(error.localizedDescription)")
        }
    }
    
    func removeListener() {
        listener?.remove()
    }

}
