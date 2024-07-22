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
            labelFont: .systemFont(ofSize: 15),
            labelNumberOfLines: 1
        )
        return label
    }()
    
    private let recentMediaMessageImageView : CustomUIImageView = {
        let imageView = CustomUIImageView(
            isCircular: false
        )
        return imageView
    }()
    
    private var recentMessageLeadingConstraint: NSLayoutConstraint!
    private var recentMessageLeadingConstraintWithImage: NSLayoutConstraint!
    private var recentMessageTrailingConstraint: NSLayoutConstraint!
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatsTableViewCell {
    
    func configure(with recentMessage: RecentMessageModel) {
        downloadReceiverUserProfileImage(from: recentMessage.userProfileImage)
        messageReceiverNameLabel.text = recentMessage.userName
        
        switch recentMessage.recentMessageType {
        case .text:
            recentMediaMessageImageView.isHidden = true
            recentMessageLeadingConstraint.isActive = true
            recentMessageLeadingConstraintWithImage.isActive = false
            recentMessageTrailingConstraint.isActive = true
            lastSentMessageLabel.text = recentMessage.recentMessageContent
        case .media:
            recentMediaMessageImageView.isHidden = false
            recentMessageLeadingConstraint.isActive = false
            recentMessageLeadingConstraintWithImage.isActive = true
            recentMessageTrailingConstraint.isActive = false
            recentMediaMessageImageView.image = UIImage(systemName: "camera.fill")
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
            
            recentMediaMessageImageView.topAnchor.constraint(equalTo: messageReceiverNameLabel.bottomAnchor,constant: 5),
            recentMediaMessageImageView.leadingAnchor.constraint(equalTo: messageReceiverProfileImage.trailingAnchor,constant: 10),
            recentMediaMessageImageView.trailingAnchor.constraint(equalTo: lastSentMessageLabel.leadingAnchor,constant: -10),

            lastSentMessageLabel.topAnchor.constraint(equalTo: messageReceiverNameLabel.bottomAnchor, constant: 7),
        ])
        
        recentMessageLeadingConstraint =             lastSentMessageLabel.leadingAnchor.constraint(equalTo: messageReceiverProfileImage.trailingAnchor, constant: 10)
        
        recentMessageLeadingConstraintWithImage = lastSentMessageLabel.leadingAnchor.constraint(equalTo: recentMediaMessageImageView.trailingAnchor)
        
        recentMessageTrailingConstraint = lastSentMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50)
        
        
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
