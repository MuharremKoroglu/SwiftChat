//
//  CustomUIStackView.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 28.05.2024.
//

import Foundation
import UIKit

final class CustomUIStackView : UIStackView {
    
    let stackAxis : NSLayoutConstraint.Axis
    let componentAlignment : UIStackView.Alignment
    let componentSpacing : CGFloat
    
    
    init(stackAxis : NSLayoutConstraint.Axis,
         componentAlignment : UIStackView.Alignment,
         componentSpacing : CGFloat = 0
    ) {
        self.stackAxis = stackAxis
        self.componentAlignment = componentAlignment
        self.componentSpacing = componentSpacing
        super.init(frame: .zero)
        setUpStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpStackView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        axis = self.stackAxis
        alignment = self.componentAlignment
        spacing = self.componentSpacing
        
        
        
    }
    
    
}
