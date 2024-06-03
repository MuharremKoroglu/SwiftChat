//
//  CustomUIActivityIndicator.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 3.06.2024.
//

import Foundation
import UIKit

final class CustomUIActivityIndicator: UIActivityIndicatorView {

    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray.withAlphaComponent(0.8)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.isHidden = true
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setUpIndicator()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpIndicator() {
        translatesAutoresizingMaskIntoConstraints = false
        color = .white
        hidesWhenStopped = true
        style = .large
        
        if let superview = self.superview {
            superview.addSubview(backgroundView)
            superview.bringSubviewToFront(self)
            
            NSLayoutConstraint.activate([
                backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                backgroundView.widthAnchor.constraint(equalToConstant: 100),
                backgroundView.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = superview {
            superview.addSubview(backgroundView)
            superview.bringSubviewToFront(self)
            
            NSLayoutConstraint.activate([
                backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                backgroundView.widthAnchor.constraint(equalToConstant: 100),
                backgroundView.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
    }
    
    override func startAnimating() {
        super.startAnimating()
        backgroundView.isHidden = false
    }
    
    override func stopAnimating() {
        super.stopAnimating()
        backgroundView.isHidden = true
    }
}


