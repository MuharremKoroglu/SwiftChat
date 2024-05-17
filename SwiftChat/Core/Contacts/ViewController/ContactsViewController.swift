//
//  ContactsViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 16.05.2024.
//

import UIKit

class ContactsViewController: UIViewController {
    
    private let contactsView = ContactsView(frame: .zero, viewModel: ContactsViewModel())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        
        view.addSubViews(contactsView)
        
        NSLayoutConstraint.activate([
        
            contactsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contactsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contactsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            contactsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        
        
        ])
        
    }
}
