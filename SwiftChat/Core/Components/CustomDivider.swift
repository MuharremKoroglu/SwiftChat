//
//  CustomDivider.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 28.05.2024.
//

import Foundation
import UIKit

class CustomDivider : UIView {
    
    let dividerColor : UIColor?
    
    init(dividerColor : UIColor? = .systemGray.withAlphaComponent(0.7)) {
        self.dividerColor = dividerColor
        super.init(frame: .zero)
        setUpDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpDivider() {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = self.dividerColor
        
    }
    
}
