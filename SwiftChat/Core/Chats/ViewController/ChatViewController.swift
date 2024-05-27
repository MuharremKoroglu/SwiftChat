//
//  ViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 10.05.2024.
//

import UIKit

class ChatViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.topItem?.setRightBarButton(UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(openPeopleList)
        ), animated: true)
        
    }
    
    @objc func openPeopleList () {
        let contactsPage = ContactsViewController()
        contactsPage.title = "Contacts"
        contactsPage.navigationItem.largeTitleDisplayMode = .automatic
        contactsPage.navigationController?.navigationBar.prefersLargeTitles = false
        let contactsPageNavigationController = UINavigationController(rootViewController: contactsPage)
        self.present(contactsPageNavigationController, animated: true)
    }


}

