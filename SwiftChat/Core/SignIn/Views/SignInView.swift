//
//  SignInView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 27.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

class SignInView: UIView {
    
    let viewModel : SignInViewModel
    
    private let bag = DisposeBag()
    
    private let spinner : CustomUIActivityIndicator = {
        let indicator = CustomUIActivityIndicator()
        return indicator
    }()
        
    private let lottieAnimation : CustomLottieAnimation = {
        let animation = CustomLottieAnimation(
            animationName: "chat"
        )
        return animation
    }()
        
    private let welcomeLabel : CustomUILabel = {
        let label = CustomUILabel(
            labelText: "Welcome to",
            labelFont: .systemFont(ofSize: 20, weight: .light)
        )
        return label
    }()
    
    private let appNameLabel : CustomUILabel = {
        let label = CustomUILabel(
            labelText: "SwiftChat",
            labelFont: .systemFont(ofSize: 30, weight: .bold)
        )
        return label
    }()
    
    private let welcomeStackView : CustomUIStackView = {
        let stack = CustomUIStackView(
            stackAxis: .vertical,
            componentAlignment: .center,
            componentSpacing: 5)
        return stack
    }()
    
    private let emailTextField : CustomUITextField = {
        let textField = CustomUITextField(
            placeHolderText: "Email"
        )
        return textField
    }()
    
    private let passwordTextField : CustomUITextField = {
        let textField = CustomUITextField(
            placeHolderText: "Password",
            isSecure: true
        )
        return textField
    }()
    
    private let emailPasswordStackView : CustomUIStackView = {
        let stack = CustomUIStackView(
            stackAxis: .vertical,
            componentAlignment: .center,
            componentSpacing: 10
        )
        return stack
    }()
    
    private let resetPasswordButton : CustomUIButton = {
        let button = CustomUIButton(
            buttonTitle: "Forgot Password?",
            buttonTitleColor: .systemOrange,
            buttonTitleFont: .systemFont(ofSize: 12, weight: .bold)
        )
        return button
    }()
    
    private let signInButton : CustomUIButton = {
        let button = CustomUIButton(
            buttonTitle: "Sign In",
            buttonColor: .systemOrange
        )
        return button
    }()
    
    private let orLabel : CustomUILabel = {
        let label = CustomUILabel(
            labelText: "Or",
            labelFont: .systemFont(ofSize: 15, weight: .light)
        )
        return label
    }()
        
    private let leftLine : CustomDivider = {
        let divider = CustomDivider()
        return divider
    }()
    
    private let rightLine : CustomDivider = {
        let divider = CustomDivider()
        return divider
    }()
    
    private let orStackView : CustomUIStackView = {
        let stack = CustomUIStackView(
            stackAxis: .horizontal,
            componentAlignment: .center,
            componentSpacing: 10
        )
        return stack
    }()
    
    private let googleSignInButton : CustomUIButton = {
        let button = CustomUIButton(
            buttonImage: UIImage(resource: .googleSign)
        )
        return button
    }()
    
    private let signInStackView : CustomUIStackView = {
        let stack = CustomUIStackView(
            stackAxis: .vertical,
            componentAlignment: .center,
            componentSpacing: 20
        )
        return stack
    }()
        
    private var signUpStackView : CustomUIStackView = {
        let stack = CustomUIStackView(
            stackAxis: .horizontal,
            componentAlignment: .center,
            componentSpacing: 5
        )
        return stack
    }()
    
    private let questionLabel : CustomUILabel = {
        let label = CustomUILabel(
            labelText: "Don't you have an account?",
            labelFont: .systemFont(ofSize: 15, weight: .light)
        )
        return label
    }()
    
    public var signUpButton : CustomUIButton = {
        let button = CustomUIButton(
            buttonTitle: "Sign Up",
            buttonTitleColor: .systemOrange
        )
        return button
    }()
    
    init(frame: CGRect, viewModel : SignInViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
        setUpConstraints()
        setUpBindings()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SignInView {
    
    func setUpViews() {
        
        addSubViews(
            spinner,
            lottieAnimation,
            welcomeStackView,
            emailPasswordStackView,
            resetPasswordButton,
            orStackView,
            signInStackView,
            signUpStackView
        )
        
        welcomeStackView.addArrangedSubview(welcomeLabel)
        welcomeStackView.addArrangedSubview(appNameLabel)
        
        emailPasswordStackView.addArrangedSubview(emailTextField)
        emailPasswordStackView.addArrangedSubview(passwordTextField)
        
        orStackView.addArrangedSubview(leftLine)
        orStackView.addArrangedSubview(orLabel)
        orStackView.addArrangedSubview(rightLine)
        
        signInStackView.addArrangedSubview(signInButton)
        signInStackView.addArrangedSubview(orStackView)
        signInStackView.addArrangedSubview(googleSignInButton)
        
        signUpStackView.addArrangedSubview(questionLabel)
        signUpStackView.addArrangedSubview(signUpButton)
        
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            lottieAnimation.centerXAnchor.constraint(equalTo: centerXAnchor),
            lottieAnimation.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            lottieAnimation.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            
            welcomeStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeStackView.topAnchor.constraint(equalTo: lottieAnimation.bottomAnchor),
            
            emailPasswordStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailPasswordStackView.topAnchor.constraint(equalTo: welcomeStackView.bottomAnchor, constant: 25),
            emailTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            emailTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06),
            passwordTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            passwordTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06),
            
            resetPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            resetPasswordButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            signInStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInStackView.topAnchor.constraint(equalTo: resetPasswordButton.bottomAnchor, constant: 20),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            leftLine.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            rightLine.heightAnchor.constraint(equalToConstant: 1),
            rightLine.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            signInButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            signInButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06),
            googleSignInButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            googleSignInButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            
            
            signUpStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
        ])
        
    }
    
    func setUpBindings() {
        
        viewModel
            .isSigning
            .bind(to: self.spinner.rx.isAnimating)
            .disposed(by: bag)
        
        resetPasswordButton
            .rx
            .tap
            .bind { [weak self] in
                self?.viewModel.sendPasswordResetMail(
                    email: self?.emailTextField.text ?? ""
                )
            }.disposed(by: bag)
        
        googleSignInButton
            .rx
            .tap
            .bind { [weak self] in
                self?.viewModel.signInWithGoogle()
            }.disposed(by: bag)
        
        signInButton
            .rx
            .tap
            .bind{ [weak self] in
                self?.viewModel.signInWithMail(
                    email: self?.emailTextField.text ?? "",
                    password: self?.passwordTextField.text ?? "")
            }.disposed(by: bag)
                
    }
    
}
