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
            action: #selector(openPeoplList)
        ), animated: true)
        
    }
    
    @objc func openPeoplList () {
        let contactsPage = ContactsViewController()
        contactsPage.title = "Contacts"
        contactsPage.navigationItem.largeTitleDisplayMode = .inline
        let contactsPageNavigationController = UINavigationController(rootViewController: contactsPage)
        self.present(contactsPageNavigationController, animated: true)
    }


}

