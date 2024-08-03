//
//  ContactsTableViewCell.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 16.05.2024.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "ContactTableViewCell"
    
    private let contactProfileImage : CustomUIImageView = {
        let imageView = CustomUIImageView(
            isCircular: true
        )
        return imageView
    }()
    
    private let contactName : CustomUILabel = {
        let label = CustomUILabel(
            labelFont: .systemFont(ofSize: 15, weight: .bold)
        )
        return label
    }()
    
    private let contactPhoneNumber : CustomUILabel = {
        let label = CustomUILabel(
            labelFont: .systemFont(ofSize: 12),
            labelNumberOfLines: 1
        )
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ContactsTableViewCell {
    
    func configure (with contact : ContactModel) {

        self.contactName.text = contact.name
        self.contactPhoneNumber.text = contact.phone
        downloadContactProfileImage(with: contact.profileImageURL)
        
    }
    
}

private extension ContactsTableViewCell {
    
    func setUpViews() {
        
        contentView.addSubViews(
            contactProfileImage,
            contactName,
            contactPhoneNumber
        )
        
    }
    
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            contactProfileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contactProfileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            contactProfileImage.heightAnchor.constraint(equalToConstant: 50),
            contactProfileImage.widthAnchor.constraint(equalToConstant: 50),
            
            contactName.leadingAnchor.constraint(equalTo: contactProfileImage.trailingAnchor, constant: 10),
            contactName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            contactName.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),

            contactPhoneNumber.topAnchor.constraint(equalTo: contactName.bottomAnchor, constant: 5),
            contactPhoneNumber.leadingAnchor.constraint(equalTo: contactProfileImage.trailingAnchor, constant: 10),
            contactPhoneNumber.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
            
        ])
        
    }
    
    func downloadContactProfileImage(with imageUrl : URL) {
        
        Task {
            let response = await SCImageDownloaderManager.shared.downloadImage(imageUrl: imageUrl)
            
            switch response {
            case .success(let data):
                self.contactProfileImage.image = UIImage(data: data)
            case .failure(_):
                self.contactProfileImage.image = UIImage(resource: .anonUser)
            }
            
        }
        
    }
    
    
}
