//
//  MessageView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.06.2024.
//

import UIKit

class MessageView: UIView {
    
    let user : ContactModel

    private let userNameLabel : CustomUILabel = {
        let label = CustomUILabel(
            labelText: "Test",
            labelFont: .systemFont(ofSize: 15),
            labelTextAlignment: .center
        )
        return label
    }()
    
    init(user : ContactModel) {
        self.user = user
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
        setUpConstraints()
        userNameLabel.text = user.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MessageView {
    
    func setUpViews() {
        
        addSubViews(
            userNameLabel
        )
        
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
        
            userNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            userNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            userNameLabel.widthAnchor.constraint(equalToConstant: 200),
            userNameLabel.heightAnchor.constraint(equalToConstant: 50)
        
        
        ])
        
        
    }
 
}
