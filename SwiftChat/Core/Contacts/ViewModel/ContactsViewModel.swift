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
    
    var filteredContacts = PublishSubject<[ContactInfo]>()
    var isFetching = PublishSubject<Bool>()
    
    private let service = NetworkService()
    private var contacts : [ContactInfo] = []
    
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
                contacts = sortedContacts
                self.filteredContacts.onNext(contacts)
            case .failure(let error):
                self.isFetching.onNext(false)
                print(error)
            }
            
        }
        
    }
    
}

extension ContactsViewModel {
    
    func filterContacts(searchText : String) {
        if searchText.isEmpty {
            filteredContacts.onNext(contacts)
        }else {
            let filteredList = contacts.filter({
                $0.name.first.lowercased().contains(searchText.lowercased()) || $0.name.last.lowercased().contains(searchText.lowercased()) || $0.phone.lowercased().contains(searchText.lowercased())}
            )
            filteredContacts.onNext(filteredList)
        }
    }
    
    
}
