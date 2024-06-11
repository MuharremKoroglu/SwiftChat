//
//  SettingsViewModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 4.06.2024.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

@MainActor
class SettingsViewModel {
    
    var profileImage = PublishSubject<UIImage>()
    var userName = PublishSubject<String>()
    var userEmail = PublishSubject<String>()
    var isProcessing = PublishSubject<Bool>()
    var isCompleted = PublishSubject<Bool>()
    
    
    func fetchUserData() {
        isProcessing.onNext(true)
        
        Task {
            
            do {
                let authenticatedUser =  SCAuthenticationManager.shared.getAuthenticatedUser()
                
                let user = try await SCDatabaseManager.shared.readData(
                    userId: authenticatedUser?.uid ?? "",
                    data: UserProfileModel.self
                )
                
                userName.onNext(user.userName)
                userEmail.onNext(user.userEmail)
                
                let result = await SCImageDownloaderManager.shared.downloadImage(imageUrl: user.profileImage)
                
                switch result {
                case .success(let imageData):
                    guard let image = UIImage(data: imageData) else {return}
                    profileImage.onNext(image)
                case .failure(_):
                    profileImage.onNext(UIImage(named: "anon_user")!)
                }
                isProcessing.onNext(false)
                isCompleted.onNext(true)
                
            }catch {
                isProcessing.onNext(false)
                isCompleted.onNext(false)
                print("Kullanıcı verileri alınamadı : \(error)")
            }
        }
    }
    
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
