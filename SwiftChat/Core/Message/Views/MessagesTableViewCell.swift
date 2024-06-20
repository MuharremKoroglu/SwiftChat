//
//  MessagesTableViewCell.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 20.06.2024.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "MessagesTableViewCell"
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageBubble: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
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

extension MessagesTableViewCell {
    
    func configure(with message: MessageModel) {
        messageLabel.text = message.messageContent
        if message.senderId == SCAuthenticationManager.shared.getAuthenticatedUser()?.uid {
            messageBubble.backgroundColor = .systemOrange
            messageBubble.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        } else {
            messageBubble.backgroundColor = .systemGray.withAlphaComponent(0.2)
            messageBubble.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        }
    }
    
}

private extension MessagesTableViewCell {
    
    func setUpViews() {
        
        addSubViews(
            messageLabel,
            messageBubble
        )
        
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            messageBubble.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageBubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            messageBubble.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            
            messageLabel.topAnchor.constraint(equalTo: messageBubble.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: messageBubble.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: messageBubble.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: messageBubble.trailingAnchor, constant: -10),
        ])
        
    }
    
    
}
