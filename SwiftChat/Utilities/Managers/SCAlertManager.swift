//
//  SCAlertmanager.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 4.06.2024.
//

import Foundation
import UIKit

struct SCAlertManager {
    
    @MainActor
    static func presentAlert(viewController : UIViewController, alertType : AlertTypes) {
        
        let alertController = UIAlertController(
            title: alertType.alertTitle,
            message: alertType.alertMessage,
            preferredStyle: alertType.alertStyle)
        
        for action in alertType.alertActions {
            alertController.addAction(action)
        }
        
        viewController.present(alertController, animated: true)
    
    }
    

}
