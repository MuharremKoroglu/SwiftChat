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
        
        navigationController?.navigationBar.topItem?.setRightBarButton(UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(closeContactsPage)
        ), animated: true)
        
    }
    
    @objc func closeContactsPage() {
        navigationController?.dismiss(animated: true)
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
