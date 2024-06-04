//
//  SCAlertmanager.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 4.06.2024.
//

import Foundation
import UIKit

struct SCAlertmanager {
    
    @MainActor
    static func presentAlert(viewController : UIViewController, alertType : AlertTypes) {
        
        let alertController = UIAlertController(title: alertType.errorTitle, message: alertType.errorMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .cancel)
        alertController.addAction(alertAction)
        viewController.present(alertController, animated: true)
    
    }
    

}
