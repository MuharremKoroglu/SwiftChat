//
//  SignInViewModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 27.05.2024.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import UIKit

@MainActor
class SignInViewModel {
    
    var completedSigning = PublishSubject<Bool>()
    var isSigning = PublishSubject<Bool>()
    var errorType = PublishSubject<AlertTypes>()
    
    private var authenticatedUserId : String {
        guard let userId = SCAuthenticationManager.shared.getAuthenticatedUser()?.uid else {
            return ""
        }
        
        return userId
    }
    
    func signInWithMail(email : String, password : String) {
        
        isSigning.onNext(true)
        
        if !email.isEmpty && !password.isEmpty {
            
            Task {
                do {
                    let user = try await SCAuthenticationManager.shared.signInWithEmailAndPassword(
                        email: email,
                        password: password
                    )
                    
                    if !user.isEmailVerified {
                        isSigning.onNext(false)
                        completedSigning.onNext(false)
                        errorType.onNext(.verifyEmailError)
                        try SCAuthenticationManager.shared.signOut()
                        try await user.sendEmailVerification()
                    }else {
                        isSigning.onNext(false)
                        completedSigning.onNext(true)
                    }
                }catch let error as NSError{
                    isSigning.onNext(false)
                    completedSigning.onNext(false)
                    let authError = AuthErrorCode.Code(rawValue: error.code)
                    switch authError {
                    case .wrongPassword,.invalidEmail,.invalidCredential:
                        errorType.onNext(.wrongPasswordOrEmail)
                    default:
                        errorType.onNext(.commonError)
                    }
                    print("Error occurred during email sign-in: \(error)")
                }
            }
        }else {
            isSigning.onNext(false)
            errorType.onNext(.blankError)
        }
        
    }
    
    func signInWithGoogle() {
        isSigning.onNext(true)
        
        Task {
            do {
                let user = try await SCAuthenticationManager.shared.signInWithGoogle()
                
                guard let userProfile = user.profile else { return }
                
                let userName = userProfile.name
                let userEmail = userProfile.email
                
                
                var userProfileImageURL: URL?
                
                if userProfile.hasImage, let profileImageURL = userProfile.imageURL(withDimension: 200) {
                    
                    if let imageData = await downloadProfileImage(with: profileImageURL) {
                        userProfileImageURL = try await SCMediaStorageManager.shared.uploadData(
                            folderName: .profilePictures,
                            fileName: authenticatedUserId,
                            data: imageData
                        )
                    }
                    
                } else {
                    
                    guard let imageData = UIImage(resource: .anonUser).jpegData(compressionQuality: 1) else {
                        return
                    }
                    
                    userProfileImageURL = try await SCMediaStorageManager.shared.uploadData(
                        folderName: .profilePictures,
                        fileName:authenticatedUserId,
                        data: imageData
                    )
                }
                
                guard let finaluserProfileImageURL = userProfileImageURL else {return}
                
                
                let userModel = FirebaseUserModel(
                    profileImage: finaluserProfileImageURL,
                    userId: authenticatedUserId,
                    userName: userName.capitalized,
                    userEmail: userEmail,
                    userPhoneNumber: "(647) 463-2587",
                    accountCreatedDate: Date()
                )
                
                
                try await SCDatabaseManager
                    .shared
                    .createData(
                        collectionId: .users,
                        documentId: authenticatedUserId,
                        data: userModel
                    )
                
                isSigning.onNext(false)
                completedSigning.onNext(true)
            } catch {
                isSigning.onNext(false)
                completedSigning.onNext(false)
                errorType.onNext(.commonError)
                print("Error occurred during Google sign-in: \(error)")
            }
        }
    }
    
    
    func sendPasswordResetMail(email : String) {
        
        isSigning.onNext(true)
        
        if !email.isEmpty {
            
            Task {
                do {
                    try await SCAuthenticationManager.shared.passwordReset(email: email)
                    isSigning.onNext(false)
                    errorType.onNext(.passwordResetMailSent)
                }catch {
                    isSigning.onNext(false)
                    errorType.onNext(.commonError)
                    print("Failed to send password reset email: \(error)")
                }
            }
            
        }else {
            isSigning.onNext(false)
            errorType.onNext(.blankError)
        }
        
    }
    
}

private extension SignInViewModel {
    
    func downloadProfileImage(with url: URL) async -> Data? {
        let result = await SCImageDownloaderManager.shared.downloadImage(imageUrl: url)
        
        switch result {
        case .success(let imageData):
            return imageData
        case .failure(_):
            return nil
        }
    }
}
