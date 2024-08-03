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
    
    private let searchController : UISearchController = {
        let searchController = UISearchController()
        searchController.automaticallyShowsCancelButton = false
        searchController.isActive = false
        return searchController
    }()
    
    private let bag = DisposeBag()

    private let contactsView : ContactsView
    
    private let viewModel : ContactsViewModel
    
    init(viewModel: ContactsViewModel) {
        self.viewModel = viewModel
        self.contactsView = ContactsView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Contacts"
        setUpViews()
        setUpConstraints()
        setUpNavigationComponents()
        setUpBindings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
        viewModel.filterContacts(searchText: "")
    }
    
}

private extension ContactsViewController {
    
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
    
    func setUpBindings() {
        
        searchController
            .searchBar
            .rx
            .text
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
