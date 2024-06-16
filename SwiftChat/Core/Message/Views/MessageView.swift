//
//  MessageView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.06.2024.
//

import UIKit

class MessageView: UIView {
    
    let user : ContactModel
    
    let userProfileImage : CustomUIImageView = {
        let image = CustomUIImageView(
            isCircular: true
        )
        return image
    }()
    
    init(user : ContactModel) {
        self.user = user
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
        setUpConstraints()
        setUpUserProfile()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MessageView {
    
    func setUpViews() {
        
        addSubViews(
            userProfileImage
        )
        
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            userProfileImage.widthAnchor.constraint(equalToConstant: 40),
            userProfileImage.heightAnchor.constraint(equalToConstant: 40)
        
        
        ])
        
        
    }
    
    func setUpUserProfile() {
        
        Task {
            
            let result = await SCImageDownloaderManager.shared.downloadImage(imageUrl: user.profileImageURL)
            
            switch result {
            case .success(let imageData):
                guard let profileImage = UIImage(data: imageData) else {return}
                userProfileImage.image = profileImage
            case .failure(_):
                guard let profileImage = UIImage(named: "anon_user") else {return}
                userProfileImage.image = profileImage
            }

        }

    }
 
}
