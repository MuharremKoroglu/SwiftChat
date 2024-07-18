//
//  CustomUIImage.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 11.06.2024.
//

import Foundation
import UIKit

class CustomUIImageView : UIImageView {
    
    let isCircular : Bool
    let cornerRadius : CGFloat
    let imageMode : UIView.ContentMode
    let clipImageBound : Bool
    let maskImageBound : Bool
    
    init(isCircular : Bool = false, 
         cornerRadius : CGFloat = 0,
         imageMode : UIView.ContentMode = .scaleAspectFit,
         clipImageBound : Bool = false,
         maskImageBound : Bool = false
    ) {
        self.isCircular = isCircular
        self.cornerRadius = cornerRadius
        self.imageMode = imageMode
        self.clipImageBound = clipImageBound
        self.maskImageBound = maskImageBound
        super.init(frame: .zero)
        setUpImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if isCircular {
            layer.cornerRadius = frame.size.width / 2
            clipsToBounds = true
        } else {
            layer.cornerRadius = self.cornerRadius
            layer.masksToBounds = maskImageBound
            clipsToBounds = clipImageBound
            
        }
    }
    
    private func setUpImageView () {
        
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = imageMode
    }
    
}
