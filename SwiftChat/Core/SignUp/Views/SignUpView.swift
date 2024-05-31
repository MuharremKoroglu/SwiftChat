//
//  SignUpView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 31.05.2024.
//

import UIKit

class SignUpView: UIView {
    
    private let signUpAnimation : CustomLottieAnimation = {
        let animation = CustomLottieAnimation(animationName: "signUp")
        return animation
    }()
    
    private let signUplabel : CustomUILabel = {
        let label = CustomUILabel(
            labelText: "Sign up",
            labelFont: .systemFont(ofSize: 35, weight: .bold)
        )
        return label
    }()
    
    private let descriptionlabel : CustomUILabel = {
        let label = CustomUILabel(
            labelText: "Create your account now!",
            labelFont: .systemFont(ofSize: 25, weight: .light),
            labelTextColor: .systemGray
        )
        return label
    }()
    
    private let greetingStackView : CustomUIStackView = {
        let stack = CustomUIStackView(
            stackAxis: .vertical,
            componentAlignment: .leading,
            componentSpacing: 15
        )
        return stack
    }()
    
    private let userNameTextField : CustomUITextField = {
        let textField = CustomUITextField(
            placeHolderText: "Username"
        )
        return textField
    }()
    
    private let userEmailTextField : CustomUITextField = {
        let textField = CustomUITextField(
            placeHolderText: "Email"
        )
        return textField
    }()
    
    private let userPasswordTextField : CustomUITextField = {
        let textField = CustomUITextField(
            placeHolderText: "Password"
        )
        return textField
    }()
    
    private let accountDetailStackView : CustomUIStackView = {
        let stack = CustomUIStackView(
            stackAxis: .vertical,
            componentAlignment: .center,
            componentSpacing: 15
        )
        return stack
    }()
    
    private let signUpButton : CustomUIButton = {
        let button = CustomUIButton(
            buttonTitle: "Sign Up",
            buttonColor: .systemOrange
        )
        return button
    }()
    
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

private extension SignUpView {
    
    func setUpViews() {
        
        addSubViews(
            signUpAnimation,
            greetingStackView,
            accountDetailStackView,
            signUpButton
        )
        
        greetingStackView.addArrangedSubview(signUplabel)
        greetingStackView.addArrangedSubview(descriptionlabel)
        
        accountDetailStackView.addArrangedSubview(userNameTextField)
        accountDetailStackView.addArrangedSubview(userEmailTextField)
        accountDetailStackView.addArrangedSubview(userPasswordTextField)
        
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            signUpAnimation.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpAnimation.widthAnchor.constraint(equalTo: widthAnchor),
            signUpAnimation.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
        
            greetingStackView.topAnchor.constraint(equalTo: signUpAnimation.bottomAnchor, constant: 10),
            greetingStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            accountDetailStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            accountDetailStackView.topAnchor.constraint(equalTo: greetingStackView.bottomAnchor, constant: 20),
            userNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            userNameTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.07),
            userEmailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userEmailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            userEmailTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.07),
            userPasswordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userPasswordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            userPasswordTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.07),
            
            signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: accountDetailStackView.bottomAnchor, constant: 30),
            signUpButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            signUpButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06),
            
        
        ])
        
        
    }
    

}
