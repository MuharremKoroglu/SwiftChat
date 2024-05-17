//
//  ContactsView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 16.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

class ContactsView: UIView {

    let viewModel : ContactsViewModel
    
    var contacts : [ContactInfo] = []
    
    private let bag = DisposeBag()
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let contactsTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    init(frame: CGRect, viewModel : ContactsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        setUpConstraints()
        setUpTableView()
        setUpBindings()
        viewModel.fetchContacts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTableView() {
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
    }

    private func setUpBindings() {
        
        viewModel
            .isFetching
            .bind(to: self.spinner.rx.isAnimating,self.contactsTableView.rx.isHidden)
            .disposed(by: bag)
            
        
        viewModel
            .contacts
            .subscribe { contacts in
                self.contacts = contacts
                self.contactsTableView.reloadData()
            }
            .disposed(by: bag)
        
    }
    
    private func setUpConstraints() {
        
        addSubViews(spinner,contactsTableView)
        
        NSLayoutConstraint.activate([
            
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        
            contactsTableView.topAnchor.constraint(equalTo: topAnchor),
            contactsTableView.leftAnchor.constraint(equalTo: leftAnchor),
            contactsTableView.rightAnchor.constraint(equalTo: rightAnchor),
            contactsTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        ])
    }

}

extension ContactsView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ContactsTableViewCell.cellIdentifier,
            for: indexPath
        ) as? ContactsTableViewCell else {
            fatalError("This cell not supported!")
        }
        
        cell.configureCell(contact: contacts[indexPath.row])
        
        return cell
    }
    
    
}
