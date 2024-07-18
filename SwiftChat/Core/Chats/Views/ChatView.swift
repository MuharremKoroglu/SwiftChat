//
//  ChatView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 16.07.2024.
//

import UIKit

class ChatView: UIView {

    private let bubble : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "pencil.circle.fill")
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(bubble)
        bubble.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            
            bubble.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            bubble.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),
            bubble.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            bubble.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),

            
            imageView.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -10),
            imageView.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -10),
        ])
    }
    
}
