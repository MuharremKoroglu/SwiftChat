//
//  CustomUITextField.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 27.05.2024.
//

import Foundation
import UIKit

final class CustomUITextField : UITextField {
    
    let placeHolder : String
    
    private let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    init(placeHolderText : String) {
        self.placeHolder = placeHolderText
        super.init(frame: .zero)
        setUpTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTextField() {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        clipsToBounds = true
        layer.cornerRadius = 20
        clearButtonMode = .whileEditing
        attributedPlaceholder = NSAttributedString(string: self.placeHolder)
        
    }
     
}

extension CustomUITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
