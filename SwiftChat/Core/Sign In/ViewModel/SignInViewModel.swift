//
//  SignInViewModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 27.05.2024.
//

import Foundation
import RxSwift
import RxCocoa

@MainActor
class SignInViewModel {
    
    var completedSigning = PublishSubject<Bool>()
    var isSigning = PublishSubject<Bool>()
    
    func signInWithMail(email : String, password : String) {
        
        if email != "" && password != "" {
            
            isSigning.onNext(true)
            
            Task {
                do {
                    let _ = try await SCAuthenticationManager.shared.signInWithEmailAndPassword(
                        email: email,
                        password: password
                    )
                    isSigning.onNext(false)
                    completedSigning.onNext(true)
                }catch{
                    isSigning.onNext(false)
                    completedSigning.onNext(false)
                    print("EMAIL ile girişte hata : \(error) ")
                }
            }
        }else {
            print("Email ve şifre alanları boş!")
        }
        
    }
    
    func signInWithGoogle() {
        
        isSigning.onNext(true)
        
        Task {
            do {
                try await SCAuthenticationManager.shared.signInWithGoogle()
                isSigning.onNext(false)
                completedSigning.onNext(true)
            }catch {
                isSigning.onNext(false)
                completedSigning.onNext(false)
                print("GOOGLE ile girişte hata : \(error)")
            }
        }
        
    }
    
    

}
