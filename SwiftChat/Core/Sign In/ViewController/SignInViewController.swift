//
//  SignInViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 27.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    private let signInView = SignInView(
        frame: .zero,
        viewModel: SignInViewModel()
    )
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
        setUpViews()
        setUpConstarints()
        bindViewModel()
    }
}

private extension SignInViewController {
    
    func setUpViews() {
        
        view.addSubViews(signInView)
        
    }
    
    func setUpConstarints() {
                
        NSLayoutConstraint.activate([
        
            signInView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            signInView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            signInView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            signInView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        
        ])
        
    }
    
    func bindViewModel() {
        
        signInView
            .signUpButton
            .rx
            .tap
            .bind { [weak self] in
                let signUpViewController = SignUpViewController()
                self?.navigationController?.pushViewController(signUpViewController, animated: true)
            }.disposed(by: disposeBag)
        
        signInView
            .viewModel
            .completedSigning
            .subscribe(onNext: { [weak self] isCompleted in
                if isCompleted {
                    let chatViewController = SCTabBarRootController()
                    chatViewController.modalPresentationStyle = .fullScreen
                    self?.present(chatViewController, animated: true)
                }
            }).disposed(by: disposeBag)
        
        signInView
            .viewModel
            .errorType
            .subscribe(onNext: { alertType in
                SCAlertmanager.presentAlert(
                    viewController: self,
                    alertType: alertType
                )
            }).disposed(by: disposeBag)
            
    }
    
    
}
