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
            labelTextColor: .white
        )
        return label
    }()
        
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
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
            bubbleView.backgroundColor = .systemOrange
            bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
            bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 50).isActive = true
        } else {
            bubbleView.backgroundColor = .systemGray.withAlphaComponent(0.2)
            bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
            bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50).isActive = true
        }
    }
    
}

private extension MessagesTableViewCell {
    
    func setUpViews() {
        
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10)
        ])
        
    }
}


