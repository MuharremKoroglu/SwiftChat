//
//  SettingModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 7.08.2024.
//

import Foundation
import UIKit

struct SettingModel : Identifiable {
    
    let id = UUID()
    let settingType : SettingType
    let settingTitle : String
    let settingIcon : UIImage?
    let settingUrl : URL?
    
}

enum SettingType {
    
    case viewCodes
    case firebase
    case rxSwift
    case usersApi
    case lottieAnimation
    case developer
    case privacyPolicy
    case termsOfService
    case contactUs
    case deleteMyAccount
    case signOut
    

}
