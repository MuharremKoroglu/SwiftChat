//
//  CustomUILabel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 28.05.2024.
//

import Foundation
import UIKit

final class CustomUILabel : UILabel {
    
    let labelText : String
    let labelFont : UIFont
    let labelTextColor : UIColor?
    
    init(labelText : String, labelFont : UIFont, labelTextColor : UIColor? = .label) {
        self.labelText = labelText
        self.labelFont = labelFont
        self.labelTextColor = labelTextColor
        super.init(frame: .zero)
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLabel() {
        
        translatesAutoresizingMaskIntoConstraints = false
        text = self.labelText
        font = self.labelFont
        textColor = self.labelTextColor
        
        
    }
    
}
