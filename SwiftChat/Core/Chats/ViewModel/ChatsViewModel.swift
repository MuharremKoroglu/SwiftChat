//
//  ChatsViewModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.05.2024.
//

import Foundation

@MainActor
class ChatsViewModel {
    
    var contacts : [ContactInfo] = []
    
    private let service = NetworkService()
    
    func fetchContacts () {
        
        Task {
            
            let response = await service.networkService(
                service: .contactsReuqest,
                data: ContactsResponseModel.self
            )
            
            switch response {
            case .success(let fetchedContacts):
                self.contacts = fetchedContacts.results
            case .failure(let error):
                print("VERİ ALIMINDA HATA : \(error)")
            }

        }

    }

}
