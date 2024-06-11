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
    
    private let profileImage : CustomUIImageView = {
        let imageView = CustomUIImageView(
            isCircular: true
        )
        return imageView
    }()
    
    private let userNameLabel : CustomUILabel = {
        let label = CustomUILabel(
            labelText: "Kullanıcı adı bulunamadı",
            labelFont: .systemFont(ofSize: 20, weight: .semibold),
            labelTextAlignment: .center
        )
        return label
    }()
    
    private let userEmailLabel : CustomUILabel = {
        let label = CustomUILabel(
            labelText: "Kullanıcı email bulunamadı",
            labelFont: .systemFont(ofSize: 15, weight: .semibold),
            labelTextAlignment: .center
        )
        return label
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
            profileImage,
            userNameLabel,
            userEmailLabel,
            signOutButton
        )
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            profileImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: topAnchor,constant: 15),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            
            userNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            userNameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 25),
            userNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            userNameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            userEmailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10),
            userEmailLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            userEmailLabel.heightAnchor.constraint(equalToConstant: 25),
            
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
        
        viewModel
            .profileImage
            .bind(to: self.profileImage.rx.image)
            .disposed(by: bag)
        
        viewModel
            .userName
            .bind(to: self.userNameLabel.rx.text)
            .disposed(by: bag)
        
        viewModel
            .userEmail
            .bind(to: self.userEmailLabel.rx.text)
            .disposed(by: bag)
        
        signOutButton
            .rx
            .tap
            .bind { [weak self] in
                self?.viewModel.signOut()
            }.disposed(by: bag)
        
        
        
        viewModel.fetchUserData()
            
    }
    
    
    
    
}


