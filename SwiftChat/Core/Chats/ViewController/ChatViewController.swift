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
    
    private let contactsPage = ContactsViewController()
    
    private let bag = DisposeBag()
    
    private let chatView = ChatView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpViews ()
        contactsPageButton()
        setUpBindings()
    }
    
    
}

private extension ChatViewController {
    
    
    func setUpViews () {
        
        view.addSubViews(chatView)
        
        
        NSLayoutConstraint.activate([
            
            chatView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chatView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            chatView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
        ])
    }
    
    
    func contactsPageButton() {
        
        navigationItem.backButtonTitle = ""
        
        navigationController?.navigationBar.topItem?.setRightBarButton(UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(openContactsList)
        ), animated: true)
        
    }
    
    
    @objc func openContactsList () {
        
        let contactsPageNavigationController = UINavigationController(rootViewController: contactsPage)
        self.present(contactsPageNavigationController, animated: true)
        
    }
    
    func setUpBindings() {
        
        contactsPage
            .selectedUser
            .subscribe (onNext: { [weak self] user in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let messageVC = MessageViewController(user: user)
                    messageVC.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(messageVC, animated: true)
                }
            }).disposed(by: bag)
        
    }
    
}

