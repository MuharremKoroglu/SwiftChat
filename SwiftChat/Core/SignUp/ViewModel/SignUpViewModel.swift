//
//  SignUpViewModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 3.06.2024.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

@MainActor
class SignUpViewModel {
    
    var isSignUpCompleted = PublishSubject<Bool>()
    var isRegistering = PublishSubject<Bool>()
    var errorType = PublishSubject<AlertTypes>()
    
    func signUp(userName : String, email : String, password: String) {
        
        isRegistering.onNext(true)
        
        if !email.isEmpty && !password.isEmpty {
            Task {
                do {
                    let user = try await SCAuthenticationManager.shared.createNewUser(
                        email: email,
                        password: password
                    )
                    
                    guard let imageData = UIImage(named: "anon_user")?.jpegData(compressionQuality: 1) else { return }
                    
                    let imageUrl = try await SCMediaStorageManager.shared.uploadData(
                        folderName: .profilePictures,
                        fileName: user.uid,
                        data: imageData
                    )
                    
                    let userModel = UserProfileModel(
                        profileImage: imageUrl,
                        userName: userName,
                        userEmail: email,
                        accountCreatedDate: Date()
                    )
                    
                    try await SCDatabaseManager.shared.createData(userId: user.uid, data: userModel)
                    
                    isRegistering.onNext(false)
                    
                    isSignUpCompleted.onNext(true)
                    
                }catch {
                    isRegistering.onNext(false)
                    isSignUpCompleted.onNext(false)
                    errorType.onNext(.commonError)
                    print("KULLANICI KAYIT EDİLEMEDİ : \(error)")
                }
            }
        }else {
            isRegistering.onNext(false)
            self.errorType.onNext(.blankError)
        }
    }

}
