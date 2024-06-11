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
                    print("EMAIL ile girişte hata : \(error) ")
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
                
                let userName = userProfile.givenName ?? ""
                let userEmail = userProfile.email
                
                let userProfileImageURL: URL
                
                if userProfile.hasImage {
                    userProfileImageURL = userProfile.imageURL(withDimension: 200) ?? URL(string: "https://www.google.com")!
                } else {
                    guard let imageData = UIImage(named: "anon_user")?.jpegData(compressionQuality: 1) else {
                        return
                    }
                    
                    userProfileImageURL = try await SCMediaStorageManager.shared.uploadData(
                        folderName: .profilePictures,
                        fileName: user.userID ?? "",
                        data: imageData
                    )
                }
                
                let authenticatedUser =  SCAuthenticationManager.shared.getAuthenticatedUser()
                
                let userModel = UserProfileModel(
                    profileImage: userProfileImageURL,
                    userName: userName,
                    userEmail: userEmail,
                    accountCreatedDate: Date()
                )
                
                try await SCDatabaseManager.shared.createData(userId: authenticatedUser?.uid ?? "", data: userModel)

                isSigning.onNext(false)
                completedSigning.onNext(true)
            } catch {
                isSigning.onNext(false)
                completedSigning.onNext(false)
                errorType.onNext(.commonError)
                print("GOOGLE ile girişte hata : \(error)")
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
                    print("Şifre Yenileme Gönderilemedi : \(error)")
                }
            }
            
        }else {
            isSigning.onNext(false)
            errorType.onNext(.blankError)
        }

    }
    
}
