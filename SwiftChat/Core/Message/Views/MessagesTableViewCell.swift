//
//  MessagesTableViewCell.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 20.06.2024.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "MessagesTableViewCell"
    
    private let messageLabel: CustomUILabel = {
        let label = CustomUILabel(
            labelTextColor: .label,
            labelNumberOfLines: 0
        )
        return label
    }()
    
    private let messageImageView: CustomUIImageView = {
        let imageView = CustomUIImageView(
            cornerRadius: 15,
            imageMode: .scaleAspectFill,
            clipImageBound: true,
            maskImageBound: true
        )
        return imageView
    }()
        
    private let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        return view
    }()
    
    private var messageLeadingConstraint: NSLayoutConstraint!
    private var messageTrailingConstraint: NSLayoutConstraint!
    
    private var mediaMessageWidthConstraint: NSLayoutConstraint!
    private var mediaMessageHeightConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        messageImageView.image = nil
        mediaMessageWidthConstraint.isActive = false
        mediaMessageHeightConstraint.isActive = false
    }

}

extension MessagesTableViewCell {
    
    func configure(with message: MessageModel) {
        switch message.messageType {
        case .text:
            messageLabel.isHidden = false
            messageImageView.isHidden = true
            messageLabel.text = message.messageContent
        case .media:
            messageLabel.isHidden = true
            messageImageView.isHidden = false
            downloadMediaMessage(from: message.messageContent)
        }
        updateConstraints(for: message)
    }
    
}

private extension MessagesTableViewCell {
    
    func setUpViews() {
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(messageImageView)
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -12),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 4),
            messageImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -4),
            messageImageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 4),
            messageImageView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -4),
            
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        

        mediaMessageWidthConstraint = messageImageView.widthAnchor.constraint(equalToConstant: 250)
        mediaMessageHeightConstraint = messageImageView.heightAnchor.constraint(equalToConstant: 250)
        
        messageLeadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        messageTrailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        
    }
    
    func updateConstraints(for message: MessageModel) {
        
        if message.senderId == SCAuthenticationManager.shared.getAuthenticatedUser()?.uid {
            bubbleView.backgroundColor = .systemOrange
            messageLeadingConstraint.isActive = false
            messageTrailingConstraint.isActive = true
        } else {
            bubbleView.backgroundColor = .systemGray.withAlphaComponent(0.3)
            messageTrailingConstraint.isActive = false
            messageLeadingConstraint.isActive = true
        }
        
        if message.messageType == .media {
            mediaMessageWidthConstraint.isActive = true
            mediaMessageHeightConstraint.isActive = true
            mediaMessageWidthConstraint.priority = .defaultHigh
            mediaMessageHeightConstraint.priority = .defaultHigh
        }else {
            mediaMessageWidthConstraint.isActive = false
            mediaMessageHeightConstraint.isActive = false
            mediaMessageWidthConstraint.priority = .defaultLow
            mediaMessageHeightConstraint.priority = .defaultLow
        }
        
    }
    
    func downloadMediaMessage(from urlString: String) {
        
        Task {
            guard let url = URL(string: urlString) else { return }
            
            let result = await SCImageDownloaderManager.shared.downloadImage(imageUrl: url)
            
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else { return }
                messageImageView.image = image
                
            case .failure(_):
                guard let image = UIImage(named: "questionmark") else { return }
                messageImageView.image = image
            }
        }
        
    }
}

