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

extension Date {
    
    func formattedMessageDate() -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: self)
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: self)
        }
    }
    
}
