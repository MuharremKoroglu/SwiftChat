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
    
    private let chatView : ChatView
    
    private let viewModel : ChatsViewModel
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpViews ()
        contactsPageButton()
        setUpBindings()
    }
    
    init() {
        self.viewModel = ChatsViewModel()
        self.chatView = ChatView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        chatView
            .selectedChat
            .subscribe (onNext: { [weak self] recentMessage in
                let messageVC = MessageViewController(user: recentMessage.receiverProfile)
                messageVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(messageVC, animated: true)
            }).disposed(by: bag)
        
        chatView
            .deletedChat
            .subscribe(onNext: { [weak self] recentMessage in
                self?.presentActionSheet(with: recentMessage)
            }).disposed(by: bag)
        
    }
    
    func presentActionSheet(with message : RecentMessageModel) {
        
        let actionSheet = UIAlertController(
            title: "Delete Chat",
            message: "This conversation will be deleted from everywhere",
            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.deleteRecentMessage(with: message)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(actionSheet, animated: true)
        
    }
    
}

