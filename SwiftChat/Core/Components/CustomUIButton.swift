//
//  CustomUIButton.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 27.05.2024.
//

import Foundation
import UIKit

class CustomUIButton : UIButton {
    
    let buttonName : String
    let buttonAction : (()->Void)?
    
    init(buttonName : String, buttonAction : (()->Void)?) {
        self.buttonName = buttonName
        self.buttonAction = buttonAction
        super.init(frame: .zero)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpButton() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        clipsToBounds = true
        layer.cornerRadius = 20
        backgroundColor = .systemOrange
        
        setTitle(self.buttonName, for: .normal)
        
        let action = UIAction { _ in
            self.buttonAction?()
        }
        
        addAction(action, for: .touchUpInside)
        
    }

}
