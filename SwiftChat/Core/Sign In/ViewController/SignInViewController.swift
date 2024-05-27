//
//  SignInViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 27.05.2024.
//

import UIKit

class SignInViewController: UIViewController {

    private let signInView = SignInView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpConstarints()
    }
    

    

}

private extension SignInViewController {
    
    func setUpConstarints() {
        
        view.addSubViews(signInView)
        
        NSLayoutConstraint.activate([
        
            signInView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            signInView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            signInView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            signInView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        
        ])
        
    }
    
    
}
