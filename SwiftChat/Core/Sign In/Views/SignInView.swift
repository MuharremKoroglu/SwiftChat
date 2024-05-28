//
//  SignInView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 27.05.2024.
//

import UIKit

class SignInView: UIView {
    
    private let lottieAnimation = CustomLottieAnimation(animationName: "chat")
    
    private let welcomeLabel = CustomUILabel(
        labelText: "Welcome to",
        labelFont: .systemFont(ofSize: 20, weight: .light)
    )
    
    private let appNameLabel = CustomUILabel(
        labelText: "SwiftChat",
        labelFont: .systemFont(ofSize: 30, weight: .bold)
    )
    
    private let emailTextField = CustomUITextField(placeHolderText: "Email")
    
    private let passwordTextField = CustomUITextField(placeHolderText: "Password")
    
    private let resetPasswordButton = CustomUIButton(
        buttonTitle: "Forgot Password?",
        buttonTitleColor : .systemOrange,
        buttonTitleFont: .systemFont(ofSize: 12, weight: .bold)
    ) {
        print("Test")
    }
    
    
    private let signInButton = CustomUIButton(
        buttonTitle: "Sign In",
        buttonColor: .systemOrange
    ) {
        print("Test")
    }
    
    private let orLabel = CustomUILabel(
        labelText: "Or",
        labelFont: .systemFont(ofSize: 15, weight: .light)
    )
    
    private let leftLine = CustomDivider()
    
    private let rightLine = CustomDivider()
    
    private let googleSignInButton = CustomUIButton(
        buttonImage: UIImage(resource: .googleSign)
    ) {
        print("Google ile giriş yapıldı!")
    }
    
    private let stackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 5
        return stack
    }()
    
    private let questionLabel = CustomUILabel(
        labelText: "Don't you have an account?",
        labelFont: .systemFont(ofSize: 15, weight: .light)
    )
    
    public var signUpButton = CustomUIButton(
        buttonTitle: "Sign Up",
        buttonTitleColor: .systemOrange
    ) {
        print("Sign Up page opened!")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
        setUpConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SignInView {
    
    func setUpViews() {
        
        addSubViews(
            lottieAnimation,
            welcomeLabel,
            appNameLabel,
            emailTextField,
            passwordTextField,
            resetPasswordButton,
            signInButton,
            orLabel,
            leftLine,
            rightLine,
            googleSignInButton,
            stackView
        )
        
        stackView.addArrangedSubview(questionLabel)
        stackView.addArrangedSubview(signUpButton)
        
    }
    
    func setUpConstraints() {
        
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
            
            resetPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            resetPasswordButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            
            signInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: resetPasswordButton.bottomAnchor, constant: 15),
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
            
            googleSignInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            googleSignInButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 25),
            googleSignInButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            googleSignInButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
        ])
        
    }
    
}
