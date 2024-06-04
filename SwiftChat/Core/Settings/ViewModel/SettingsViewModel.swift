//
//  SettingsViewModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 4.06.2024.
//

import Foundation
import RxSwift
import RxCocoa

@MainActor
class SettingsViewModel {
    
    var isProcessing = PublishSubject<Bool>()
    var isCompleted = PublishSubject<Bool>()
    
    func signOut() {
        isProcessing.onNext(true)
        do {
            try SCAuthenticationManager.shared.signOut()
            isProcessing.onNext(false)
            isCompleted.onNext(true)
        }catch{
            isProcessing.onNext(false)
            isCompleted.onNext(false)
            print("ÇIKIŞ YAPILAMADI : \(error)")
        }
    }

}
