//
//  SettingsViewController.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 13.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    
    private let settingsView = SettingsView(viewModel: SettingsViewModel())
    
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpViews()
        setUpConstraints()
        setUpBindings()
    }
    
}

private extension SettingsViewController {
    
    func setUpViews() {
        view.addSubViews(settingsView)
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            settingsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            settingsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            
        ])
        
    }
    
    func setUpBindings() {
        
        settingsView
            .viewModel
            .isCompleted
            .subscribe(onNext: { [weak self] isCompleted in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let signInViewController = SignInViewController()
                    signInViewController.modalPresentationStyle = .fullScreen
                    self?.present(signInViewController, animated: true)
                }
            }).disposed(by: bag)
    
    }
    
}
