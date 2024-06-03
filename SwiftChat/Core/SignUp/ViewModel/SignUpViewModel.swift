//
//  SignUpViewModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 3.06.2024.
//

import Foundation
import RxSwift
import RxCocoa

@MainActor
class SignUpViewModel {
    
    var isSignUpCompleted = PublishSubject<Bool>()
    var isRegistering = PublishSubject<Bool>()
    
    func signUp(email : String, password: String) {
        
        isRegistering.onNext(true)
        
        Task {
            do {
                try await SCAuthenticationManager.shared.createNewUser(
                    email: email,
                    password: password
                )
                isRegistering.onNext(false)
                isSignUpCompleted.onNext(true)
            }catch {
                isRegistering.onNext(false)
                isSignUpCompleted.onNext(false)
                print("KULLANICI KAYIT EDİLEMEDİ : \(error)")
                
            }
        }
        
    }
    
    
    
    
    
}
