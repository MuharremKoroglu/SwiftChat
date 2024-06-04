//
//  AlertTypes.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 4.06.2024.
//

import Foundation

enum AlertTypes {
    
    case commonError
    case blankError
    case verifyEmailError
    case wrongPasswordOrEmail
    case passwordResetMailSent
    
    var errorTitle : String {
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
        }
    }
    
    var errorMessage : String {
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
        }
    }

}
