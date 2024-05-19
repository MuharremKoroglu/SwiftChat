//
//  ContactsViewModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 17.05.2024.
//

import Foundation
import RxSwift
import RxCocoa

@MainActor
class ContactsViewModel {
    
    var contacts = PublishSubject<[ContactInfo]>()
    var isFetching = PublishSubject<Bool>()
    
    private let service = NetworkService()
    
    func fetchContacts () {
        
        self.isFetching.onNext(true)
        
        Task {
            
            let response = await service.networkService(
                service: .contactsReuqest,
                data: ContactsResponseModel.self
            )
            
            switch response {
            case .success(let fetchedContacts):
                let sortedContacts = fetchedContacts.results.sorted{
                    $0.name.first < $1.name.first
                }
                self.isFetching.onNext(false)
                self.contacts.onNext(sortedContacts)
            case .failure(let error):
                self.isFetching.onNext(false)
                print(error)
            }
            
        }
        
    }
    
}
