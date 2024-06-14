//
//  ContactsViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 16.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

class ContactsViewController: UIViewController {
    
    let selectedUser = PublishSubject<ContactModel>()
    
    private let searchController = UISearchController()
    private let contactsView = ContactsView(
        frame: .zero,
        viewModel: ContactsViewModel()
    )
    
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Contacts"
        setUpViews()
        setUpConstraints()
        setUpNavigationComponents()
        setUpBindings()
    }
    

}

private extension ContactsViewController {
    
    
    @objc func closeContactsPage() {
        
        navigationController?.dismiss(animated: true)
        
    }
    
    func setUpNavigationComponents() {
        
        navigationController?.navigationBar.topItem?.setRightBarButton(UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(closeContactsPage)
        ), animated: true)
        
        navigationItem.searchController = searchController
        
    }
    
    func setUpViews() {
        
        view.addSubViews(
            contactsView
        )
        
    }
    
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            contactsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contactsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contactsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            contactsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
        ])
        
    }
    
    func setUpBindings() {
        
        searchController.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe { [weak self] searchtext in
                self?.contactsView
                    .viewModel
                    .filterContacts(
                        searchText: searchtext
                    )
            }.disposed(by: bag)
        
        contactsView
            .selectedUser
            .subscribe(onNext: { [weak self] user in
                self?.selectedUser.onNext(user)
                self?.closeContactsPage()
            })
            .disposed(by: bag)
            
        
    }
    
    
    
}
