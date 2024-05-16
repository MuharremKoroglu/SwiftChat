//
//  ViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 10.05.2024.
//

import UIKit

class ChatViewController: UIViewController {
    
    private let chatsViewModel = ChatsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.setRightBarButton(UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(openPeoplList)
        ), animated: true)
        
        chatsViewModel.fetchContacts()
    }
    
    @objc func openPeoplList () {
        let contactsPage = ContactsViewController()
        contactsPage.title = "Contacts"
        contactsPage.navigationItem.largeTitleDisplayMode = .inline
        let contactsPageNavigationController = UINavigationController(rootViewController: contactsPage)
        self.present(contactsPageNavigationController, animated: true)
    }


}

