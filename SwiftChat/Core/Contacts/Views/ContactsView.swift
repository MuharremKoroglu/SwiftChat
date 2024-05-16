//
//  ContactsView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 16.05.2024.
//

import UIKit

class ContactsView: UIView {

    let viewModel : ChatsViewModel
    
    private let contactsTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    init(frame: CGRect, viewModel : ChatsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        
        addSubViews(contactsTableView)
        
        NSLayoutConstraint.activate([
        
            contactsTableView.topAnchor.constraint(equalTo: topAnchor),
            contactsTableView.leftAnchor.constraint(equalTo: leftAnchor),
            contactsTableView.rightAnchor.constraint(equalTo: rightAnchor),
            contactsTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        ])
    }

}

extension ContactsView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ContactsTableViewCell.cellIdentifier,
            for: indexPath
        ) as? ContactsTableViewCell else {
            fatalError("This cell not supported!")
        }
        
        cell.configureCell(contact: viewModel.contacts[indexPath.row])
        
        return cell
    }
    
    
}
