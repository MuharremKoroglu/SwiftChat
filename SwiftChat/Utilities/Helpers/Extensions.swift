//
//  Extensions.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 16.05.2024.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubViews (_ views : UIView ...) {
        views.forEach ({
            addSubview($0)
        })
    }
    
}
