//
//  ChatTableViewCell.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 18.07.2024.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "ChatsTableViewCell"
    
    private let messageReceiverProfileImage : CustomUIImageView = {
        let imageView = CustomUIImageView(
            isCircular: true
        )
        return imageView
    }()
    
    private let messageReceiverNameLabel : CustomUILabel = {
        let label = CustomUILabel(
            labelFont: .systemFont(ofSize: 18, weight: .bold),
            labelNumberOfLines: 1
        )
        return label
    }()
    
    private let lastSentMessageLabel : CustomUILabel = {
        let label = CustomUILabel(
            labelFont: .systemFont(ofSize: 16),
            labelTextColor: .systemGray,
            labelNumberOfLines: 1
        )
        return label
    }()
    
    private let recentMediaMessageImageView : CustomUIImageView = {
        let imageView = CustomUIImageView(
            isCircular: false,
            selectedImage: UIImage(systemName: "camera.fill"),
            imageTintColor: .systemGray
        )
        return imageView
    }()
    
    private var recentMessageLeadingConstraint: NSLayoutConstraint!
    private var recentMessageLeadingConstraintWithImage: NSLayoutConstraint!
    private var recentMessageTrailingConstraint: NSLayoutConstraint!
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageReceiverProfileImage.image = nil
        messageReceiverNameLabel.text = nil
        lastSentMessageLabel.text = nil
        recentMediaMessageImageView.image = nil
    }
    
}

extension ChatsTableViewCell {
    
    func configure(with recentMessage: RecentMessageModel) {
        
        downloadReceiverUserProfileImage(from: recentMessage.receiverProfile.profileImageURL)
        messageReceiverNameLabel.text = recentMessage.receiverProfile.name
        
        switch recentMessage.recentMessageType {
        case .text:
            recentMediaMessageImageView.isHidden = true
            recentMessageLeadingConstraint.isActive = true
            recentMessageLeadingConstraintWithImage.isActive = false
            lastSentMessageLabel.text = recentMessage.recentMessageContent
        case .media:
            recentMediaMessageImageView.isHidden = false
            recentMessageLeadingConstraint.isActive = false
            recentMessageLeadingConstraintWithImage.isActive = true
            lastSentMessageLabel.text = "Media"
        }
    }
    
    
    
}


private extension ChatsTableViewCell {
    
    func setUpViews() {
        
        contentView.addSubViews(
            messageReceiverProfileImage,
            messageReceiverNameLabel,
            lastSentMessageLabel,
            recentMediaMessageImageView
        )
        
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            messageReceiverProfileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageReceiverProfileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageReceiverProfileImage.heightAnchor.constraint(equalToConstant: 55),
            messageReceiverProfileImage.widthAnchor.constraint(equalToConstant: 55),
            
            messageReceiverNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageReceiverNameLabel.leadingAnchor.constraint(equalTo: messageReceiverProfileImage.trailingAnchor, constant: 10),
            messageReceiverNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            recentMediaMessageImageView.topAnchor.constraint(equalTo: messageReceiverNameLabel.bottomAnchor,constant: 8),
            recentMediaMessageImageView.leadingAnchor.constraint(equalTo: messageReceiverProfileImage.trailingAnchor,constant: 10),

            lastSentMessageLabel.topAnchor.constraint(equalTo: messageReceiverNameLabel.bottomAnchor, constant: 9),
            lastSentMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -55)
        ])
        
        recentMessageLeadingConstraint =             lastSentMessageLabel.leadingAnchor.constraint(equalTo: messageReceiverProfileImage.trailingAnchor, constant: 10)
        
        recentMessageLeadingConstraintWithImage = lastSentMessageLabel.leadingAnchor.constraint(equalTo: recentMediaMessageImageView.trailingAnchor,constant: 5)
        
    }
    
    func downloadReceiverUserProfileImage(from url : URL) {
        
        Task {
            
            let result = await SCImageDownloaderManager.shared.downloadImage(imageUrl: url)
            
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else { return }
                messageReceiverProfileImage.image = image
                
            case .failure(_):
                let image = UIImage(resource: .anonUser)
                messageReceiverProfileImage.image = image
            }
        }
        
    }
    
    
    
}
