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
        setUpConstarints()
        bindViewModel()
        Task{
            do{
                try SCAuthenticationManager.shared.signOut()
                print("ÇIKIŞ BAŞARILI")
            }catch{
                print("ÇIKIŞTA HATA : \(error)")
            }
        }
    }
}

private extension SignInViewController {
    
    func bindViewModel() {
        
        signInView
            .signUpButton
            .rx
            .tap
            .bind {
                let signUpViewController = SignUpViewController()
                self.navigationController?.pushViewController(signUpViewController, animated: true)
            }.disposed(by: disposeBag)
        
        signInView
            .viewModel
            .completedSigning
            .subscribe(onNext: { [weak self] isCompleted in
                let chatViewController = SCTabBarRootController()
                chatViewController.modalPresentationStyle = .fullScreen
                self?.present(chatViewController, animated: true)
            }).disposed(by: disposeBag)
            
        
        
    }
    
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
