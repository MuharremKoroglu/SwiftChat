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
    
    private var authenticatedUserId : String {
        guard let userId = SCAuthenticationManager.shared.getAuthenticatedUser()?.uid else {
            return ""
        }
        
        return userId
    }
    
    private let service = NetworkService()
    private var contacts: [ContactModel] = []
    
    init() {
        fetchContacts()
    }
    
    func fetchContacts() {

        isFetching.onNext(true)
        
        Task {
            
            let fetchedFirebaseUsers = try await SCDatabaseManager.shared.readMultipleData(
                collectionId: .users,
                data: FirebaseUserModel.self
            )
            
            let contactApiResponse = await self.service.networkService(
                service: .contactsReuqest,
                data: APIUsersModel.self
            )
            
            switch contactApiResponse {
            case .success(let fetchedApiUsers):
                
                let firebaseUsers = fetchedFirebaseUsers
                    .filter({$0.userId != authenticatedUserId})
                    .map({ContactModel(from: $0)})
                
                let apiUsers = fetchedApiUsers.results.map({ContactModel(from: $0)})
                
                contacts = firebaseUsers + apiUsers
                
                contacts.sort{$0.name < $1.name}
                
                let sections = self.groupContactsByLetter(contacts: contacts)
                
                self.isFetching.onNext(false)
                
                self.filteredContacts.onNext(sections)
                
            case .failure(let error):
                
                self.isFetching.onNext(false)
                
                print("Failed to fetch contacts: \(error)")
            }
            
            
        }
        
    }
    
}

extension ContactsViewModel {
        
    func filterContacts(searchText: String) {
        if searchText.isEmpty {
            let sections = self.groupContactsByLetter(contacts: contacts)
            filteredContacts.onNext(sections)
        } else {
            let filteredList = contacts.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                ($0.phone.lowercased().contains(searchText.lowercased()))
            }
            let sections = self.groupContactsByLetter(contacts: filteredList)
            filteredContacts.onNext(sections)
        }
    }
    
}

private extension ContactsViewModel {
    
    func groupContactsByLetter(contacts: [ContactModel]) -> [ContactSection] {
        let groupedDict = Dictionary(grouping: contacts) {
            $0.name.prefix(1)
        }
        
        let sortedGroupedDict = groupedDict.map {
            ContactSection(letter: String($0.key), contacts: $0.value)
        }.sorted { $0.letter < $1.letter }
        
        return sortedGroupedDict
    }
    
}

