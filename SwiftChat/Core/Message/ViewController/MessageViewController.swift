//
//  MessageViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.06.2024.
//

import UIKit

class MessageViewController: UIViewController {
    
    let user : ContactModel
    
    private let messageView : MessageView
    
    init(user: ContactModel) {
        self.user = user
        self.messageView = MessageView(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
        setUpContraints()
    }

}

private extension MessageViewController {
    
    func setUpView() {
        
        view.addSubViews(
            messageView
        )

    }
    
    func setUpContraints() {
        
        NSLayoutConstraint.activate([
        
            messageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            messageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            messageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)

        ])
 
    }
 
}
