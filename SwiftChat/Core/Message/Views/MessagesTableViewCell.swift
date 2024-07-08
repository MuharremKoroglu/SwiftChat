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
        let label = CustomUILabel(labelTextColor: .label)
        label.numberOfLines = 0
        return label
    }()
        
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!

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
        updateConstraints(for: message)
    }
}


private extension MessagesTableViewCell {
    
    func setUpViews() {
        
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -12),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        ])
        
        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
    
    }
    
    func updateConstraints(for message: MessageModel) {
        if message.senderId == SCAuthenticationManager.shared.getAuthenticatedUser()?.uid {
            bubbleView.backgroundColor = .systemOrange
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        } else {
            bubbleView.backgroundColor = .systemGray.withAlphaComponent(0.3)
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
        }
        

    }
    
}


