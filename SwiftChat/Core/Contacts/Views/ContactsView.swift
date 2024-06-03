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
    
    let viewModel: ContactsViewModel
    
    var contactSections: [ContactSection] = []
    
    private let bag = DisposeBag()
        
    private let spinner : CustomUIActivityIndicator = {
        let indicator = CustomUIActivityIndicator()
        return indicator
    }()
    
    private let contactsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 70
        return tableView
    }()
    
    init(frame: CGRect, viewModel: ContactsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setUpConstraints()
        setUpTableView()
        setUpBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTableView () {
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
    }
    
    private func setUpBindings() {
        
        viewModel
            .isFetching
            .bind(to: self.spinner.rx.isAnimating, self.contactsTableView.rx.isHidden)
            .disposed(by: bag)
        
        viewModel
            .filteredContacts
            .subscribe(onNext: { [weak self] sections in
                self?.contactSections = sections
                self?.contactsTableView.reloadData()
            })
            .disposed(by: bag)
        
        viewModel.fetchContacts()
    }
    
    private func setUpConstraints() {
        
        addSubViews(spinner, contactsTableView)
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactSections[section].contacts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactSections[section].letter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.cellIdentifier, for: indexPath) as! ContactsTableViewCell
        let contact = contactSections[indexPath.section].contacts[indexPath.row]
        cell.configureCell(contact: contact)
        return cell
    }
    
    
}


