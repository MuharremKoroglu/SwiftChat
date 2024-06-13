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
    private var contacts: [ContactModel] = []
    
    func fetchContacts() {
        self.isFetching.onNext(true)
        
        Task {
            let response = await service.networkService(
                service: .contactsReuqest,
                data: APIUsersModel.self
            )
            
            do {
                let registeredUsers = try await SCDatabaseManager.shared.readMultipleData(
                    collectionId: .users,
                    data: FirebaseUserModel.self
                )
                
                switch response {
                case .success(let fetchedContacts):
                    
                    let apiUsers = fetchedContacts.results.map({ContactModel(from: $0)})
                    
                    let firebaseUsers = registeredUsers.map({ContactModel(from: $0)})
                    
                    contacts = apiUsers + firebaseUsers
                    contacts.sort{$0.name < $1.name}
                    
                    let sections = self.groupContactsByLetter(contacts: contacts)
                    self.filteredContacts.onNext(sections)
                    self.isFetching.onNext(false)
                case .failure(let error):
                    self.isFetching.onNext(false)
                    print(error)
                }
            }catch {
                print("Kullanıcı verileri alınırken bir hata oluştu : \(error)")
            }
            
        }
    }
    
}

extension ContactsViewModel {
    
    private func groupContactsByLetter(contacts: [ContactModel]) -> [ContactSection] {
        let groupedDict = Dictionary(grouping: contacts) {
            $0.name.prefix(1)
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
                $0.name.lowercased().contains(searchText.lowercased()) ||
                ($0.phone.lowercased().contains(searchText.lowercased()))
            }
            let sections = self.groupContactsByLetter(contacts: filteredList)
            filteredContacts.onNext(sections)
        }
    }
    
}

