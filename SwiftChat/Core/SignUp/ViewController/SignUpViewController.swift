//
//  SignUpViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 28.05.2024.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let signUpView = SignUpView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpViews()
        setUpConstraints()
        
    }

}

private extension SignUpViewController {
    
    func setUpViews() {
        view.addSubViews(signUpView)
    }
    
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
        
            signUpView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            signUpView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            signUpView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            signUpView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
    
        ])
        
    }  
}
