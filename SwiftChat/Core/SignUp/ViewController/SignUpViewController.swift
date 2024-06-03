//
//  SignUpViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 28.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    
    private let signUpView = SignUpView(
        frame: .zero,
        viewModel: SignUpViewModel()
    )
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpViews()
        setUpConstraints()
        setupBindings()
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
    
    func setupBindings() {
        
        signUpView
            .viewModel
            .isSignUpCompleted
            .subscribe(onNext: { [weak self] isCompleted in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
        
    }
}
