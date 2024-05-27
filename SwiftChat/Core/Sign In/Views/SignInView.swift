//
//  SignInView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 27.05.2024.
//

import UIKit
import Lottie

class SignInView: UIView {

    private let lottieAnimation : LottieAnimationView = {
        let animation = LottieAnimationView()
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.animation = LottieAnimation.named("chat")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        return animation
    }()
    
    private let welcomeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome to"
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.textColor = .label
        return label
    }()
    
    private let appNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SwiftChat"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let emailTextField = CustomUITextField(placeHolderText: "Email")
    
    private let passwordTextField = CustomUITextField(placeHolderText: "Password")
    
    private let signInButton = CustomUIButton(buttonName: "Sign In") {
        print("TEST")
    }
    
    private let orLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Or"
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .label
        return label
    }()
    
    private let leftLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray.withAlphaComponent(0.7)
        return view
    }()
    
    private let rightLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray.withAlphaComponent(0.7)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setUpConstraints()
        lottieAnimation.play()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        
        addSubViews(
            lottieAnimation,
            welcomeLabel,
            appNameLabel,
            emailTextField,
            passwordTextField,
            signInButton,
            orLabel,
            leftLine,
            rightLine
        )
        
        NSLayoutConstraint.activate([
        
            lottieAnimation.centerXAnchor.constraint(equalTo: centerXAnchor),
            lottieAnimation.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            lottieAnimation.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: lottieAnimation.bottomAnchor),
            
            appNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            appNameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 15),
            
            emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 25),
            emailTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            emailTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06),
            
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            passwordTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06),
            
            signInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            signInButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            signInButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06),
            
            orLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            orLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 25),
            
            leftLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor),
            leftLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            leftLine.trailingAnchor.constraint(equalTo: orLabel.leadingAnchor, constant: -10),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            
            rightLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor),
            rightLine.leadingAnchor.constraint(equalTo: orLabel.trailingAnchor, constant: 10),
            rightLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100),
            rightLine.heightAnchor.constraint(equalToConstant: 1),

            
        
            
            
        ])
        
    }
    

}
