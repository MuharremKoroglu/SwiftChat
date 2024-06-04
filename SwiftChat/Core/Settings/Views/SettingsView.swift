//
//  SettingsView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 4.06.2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SettingsView : UIView {
    
    let viewModel : SettingsViewModel
    
    private let bag = DisposeBag()
    
    private let spinner : CustomUIActivityIndicator = {
        let indicator = CustomUIActivityIndicator()
        return indicator
    }()
    
    private let signOutButton : CustomUIButton = {
        let button = CustomUIButton(
            buttonTitle: "Sign Out",
            buttonColor: .systemOrange
        )
        return button
        
    }()
    
    
    init(viewModel : SettingsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setUpView()
        setUpConstraints()
        setUpBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SettingsView {
    
    func setUpView() {
        
        addSubViews(
            spinner,
            signOutButton
        )
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            signOutButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
            signOutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            signOutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            signOutButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08),

        ])

    }
    
    func setUpBindings() {
        
        viewModel
            .isProcessing
            .bind(to: self.spinner.rx.isAnimating)
            .disposed(by: bag)
        
        
        signOutButton
            .rx
            .tap
            .bind { [weak self] in
                self?.viewModel.signOut()
            }.disposed(by: bag)
            
    }
    
    
    
    
}


