//
//  ViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 10.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

class ChatViewController: UIViewController {
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
        
        navigationController?.navigationBar.topItem?.setRightBarButton(UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(openContactsList)
        ), animated: true)
        
    }
    
    @objc func openContactsList () {
        let contactsPage = ContactsViewController()
        
        contactsPage
            .selectedUser
            .subscribe (onNext: { [weak self] user in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.navigateToMessageViewController(with: user)
                }
            }).disposed(by: bag)
        
        
        let contactsPageNavigationController = UINavigationController(rootViewController: contactsPage)
        self.present(contactsPageNavigationController, animated: true)
    }
    
    
    func navigateToMessageViewController(with user: ContactModel) {
        let messageVC = MessageViewController(user: user)
        self.navigationController?.pushViewController(messageVC, animated: true)
    }


}

