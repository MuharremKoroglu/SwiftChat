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
    
    init(isCircular : Bool = false) {
        self.isCircular = isCircular
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
            layer.cornerRadius = 0
            clipsToBounds = false
        }
    }
    
    private func setUpImageView () {
        
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
    }
    
}
