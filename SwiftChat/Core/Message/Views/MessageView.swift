//
//  MessageView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.06.2024.
//

import UIKit

class MessageView: UIView {
    
    let user : ContactModel
    
    private let addMediaButton : CustomUIButton = {
        let button = CustomUIButton(
            buttonImage: UIImage(systemName: "plus.circle.fill")
        )
        return button
    }()
    
    private let messageTextView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 15)
        textView.backgroundColor = .systemGray.withAlphaComponent(0.3)
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        return textView
    }()
    
    private let sendMessageButton : CustomUIButton = {
        let button = CustomUIButton(
            buttonTitle: "Send",
            buttonColor: .systemOrange
        )
        return button
    }()
    
    private let messageStackView : CustomUIStackView = {
        let stackView = CustomUIStackView(
            stackAxis: .horizontal,
            componentAlignment: .center,
            componentSpacing: 10
        )
        return stackView
    }()
    
    
    init(user : ContactModel) {
        self.user = user
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
        setUpConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MessageView {
    
    func setUpViews() {
        
        addSubViews(
            messageStackView
        )
        
        messageStackView.addArrangedSubview(addMediaButton)
        messageStackView.addArrangedSubview(messageTextView)
        messageStackView.addArrangedSubview(sendMessageButton)
        
        addMediaButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addMediaButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        messageTextView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        messageTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            messageStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            messageStackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            messageStackView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -5),
            messageStackView.heightAnchor.constraint(equalToConstant: 40),
            
            addMediaButton.heightAnchor.constraint(equalTo: messageStackView.heightAnchor),
        
            messageTextView.heightAnchor.constraint(equalTo: messageStackView.heightAnchor),
            
            sendMessageButton.heightAnchor.constraint(equalTo: messageStackView.heightAnchor),
            sendMessageButton.widthAnchor.constraint(equalTo: messageStackView.widthAnchor, multiplier: 0.18),
            
            
            
        ])
        
        
    }
    
    
    
}
