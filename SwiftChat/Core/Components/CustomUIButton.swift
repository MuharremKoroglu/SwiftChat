//
//  CustomUIButton.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 27.05.2024.
//

import Foundation
import UIKit

class CustomUIButton : UIButton {
    
    let buttonTitle : String?
    let buttonImage : UIImage?
    let buttonColor : UIColor?
    let buttonTitleColor : UIColor?
    let buttonTitleFont : UIFont?
    let buttonAction : (()->Void)?
    
    init(buttonTitle : String? = nil, buttonImage : UIImage? = nil, buttonColor : UIColor? = nil, buttonTitleColor : UIColor? = nil, buttonTitleFont : UIFont? = nil, buttonAction : (()->Void)?) {
        self.buttonTitle = buttonTitle
        self.buttonImage = buttonImage
        self.buttonColor = buttonColor
        self.buttonTitleColor = buttonTitleColor
        self.buttonTitleFont = buttonTitleFont
        self.buttonAction = buttonAction
        super.init(frame: .zero)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpButton() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = self.buttonColor
        titleLabel?.font = self.buttonTitleFont
        layer.cornerRadius = 20
        
        setImage(self.buttonImage, for: .normal)
        setTitle(self.buttonTitle, for: .normal)
        setTitleColor(self.buttonTitleColor, for: .normal)
        
        let action = UIAction { _ in
            self.buttonAction?()
        }
        
        addAction(action, for: .touchUpInside)
        
    }

}
