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
    
    var filteredContacts = PublishSubject<[ContactSection]>()
    var isFetching = PublishSubject<Bool>()
    
    private let service = NetworkService()
    private var contacts: [ContactInfo] = []
    
    func fetchContacts() {
        self.isFetching.onNext(true)
        
        Task {
            let response = await service.networkService(
                service: .contactsReuqest,
                data: ContactsResponseModel.self
            )
            
            switch response {
            case .success(let fetchedContacts):
                let sortedContacts = fetchedContacts.results.sorted { $0.name.first < $1.name.first }
                self.isFetching.onNext(false)
                contacts = sortedContacts
                let sections = self.groupContactsByLetter(contacts: sortedContacts)
                self.filteredContacts.onNext(sections)
            case .failure(let error):
                self.isFetching.onNext(false)
                print(error)
            }
        }
    }
    
}

extension ContactsViewModel {
    
    private func groupContactsByLetter(contacts: [ContactInfo]) -> [ContactSection] {
        let groupedDict = Dictionary(grouping: contacts) {
            $0.name.first.prefix(1)
        }
        
        let sortedGroupedDict = groupedDict.map {
            ContactSection(letter: String($0.key), contacts: $0.value)
        }.sorted { $0.letter < $1.letter }
        
        return sortedGroupedDict
    }
    
    func filterContacts(searchText: String) {
        if searchText.isEmpty {
            let sections = self.groupContactsByLetter(contacts: contacts)
            filteredContacts.onNext(sections)
        } else {
            let filteredList = contacts.filter {
                $0.name.first.lowercased().contains(searchText.lowercased()) ||
                $0.name.last.lowercased().contains(searchText.lowercased()) ||
                $0.phone.lowercased().contains(searchText.lowercased())
            }
            let sections = self.groupContactsByLetter(contacts: filteredList)
            filteredContacts.onNext(sections)
        }
    }
    
}

