//
//  AlertTypes.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 4.06.2024.
//

import Foundation
import UIKit

enum AlertTypes {
    
    case commonError
    case blankError
    case verifyEmailError
    case wrongPasswordOrEmail
    case passwordResetMailSent
    case sendMedia(cameraHandler: (() -> Void)?, photoLibraryHandler: (() -> Void)?)
    case deleteRecentMessage(deleteRecentMessageHandler: (() -> Void)?)
        
    var alertTitle : String {
        switch self {
        case .commonError:
            "Oops! Something went wrong."
        case .blankError:
            "Hold on!"
        case .verifyEmailError:
            "Verify Your Email"
        case .wrongPasswordOrEmail:
            "Sign In Failed"
        case .passwordResetMailSent:
            "Reset Your Password"
        case .sendMedia:
            "Send Media"
        case .deleteRecentMessage:
            "Delete Chat"
        }
    }
    
    var alertMessage : String {
        switch self {
        case .commonError:
            "We encountered an error. Please try again later."
        case .blankError:
            "Please fill in all required fields to proceed."
        case .verifyEmailError:
            "A verification email has been sent to your email address. Please verify to continue using the app."
        case .wrongPasswordOrEmail:
            "The username or password you entered is incorrect. Please try again."
        case .passwordResetMailSent:
            "We have sent an e-mail to your e-mail address to reset your password."
        case .sendMedia:
            "Where would you like to use it?"
        case .deleteRecentMessage:
            "This conversation will be deleted from everywhere"
        }
    }
    
    var alertStyle: UIAlertController.Style {
        switch self {
        case .sendMedia, .deleteRecentMessage:
            return .actionSheet
        default:
            return .alert
        }
    }
    
    var alertActions : [UIAlertAction] {
        switch self {
        case .sendMedia(let cameraHandler, let photoLibraryHandler):
            return [
                UIAlertAction(title: "Camera", style: .default, handler: { _ in
                    cameraHandler?()
                }),
                UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
                    photoLibraryHandler?()
                }),
                UIAlertAction(title: "Cancel", style: .cancel)
            ]
        case .deleteRecentMessage(let deleteRecentMessageHandler):
            return [
                UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    deleteRecentMessageHandler?()
                }),
                UIAlertAction(title: "Cancel", style: .cancel)
            ]
        default:
            return [UIAlertAction(title: "Okay", style: .cancel)]
        }
        
        
    }
    
    

}
