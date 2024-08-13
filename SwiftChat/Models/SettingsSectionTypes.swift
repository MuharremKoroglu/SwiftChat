//
//  SettingsTypes.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 4.08.2024.
//

import Foundation
import UIKit

enum SettingsSectionTypes : CaseIterable {
    
    case project
    case developer
    case legal
    case contactUs
    case account

    var buttons : [SettingModel] {
        
        switch self {
        case .project:
            return [
                SettingModel(
                    settingType: .viewCodes,
                    settingTitle: "View Codes",
                    settingIcon: UIImage(systemName: "hammer"),
                    settingUrl: URL(string: "https://github.com/MuharremKoroglu/SwiftChat")
                ),
                SettingModel(
                    settingType: .firebase,
                    settingTitle: "Firebase",
                    settingIcon: UIImage(systemName: "server.rack"),
                    settingUrl: URL(string: "https://firebase.google.com/")
                ),
                SettingModel(
                    settingType: .rxSwift,
                    settingTitle: "RxSwift",
                    settingIcon: UIImage(systemName: "app.connected.to.app.below.fill"),
                    settingUrl: URL(string: "https://github.com/ReactiveX/RxSwift")
                    
                ),
                SettingModel(
                    settingType: .usersApi,
                    settingTitle: "Users API Reference",
                    settingIcon: UIImage(systemName: "person"),
                    settingUrl: URL(string: "https://randomuser.me/")
                ),
                SettingModel(
                    settingType: .lottieAnimation,
                    settingTitle: "Lottie Animations",
                    settingIcon: UIImage(systemName: "circle.circle"),
                    settingUrl: URL(string: "https://lottiefiles.com/")
                )
            ]
        case .developer:
            return [
                SettingModel(
                    settingType: .developer,
                    settingTitle: "Developer",
                    settingIcon: UIImage(systemName: "laptopcomputer"),
                    settingUrl:  URL(string: "https://www.linkedin.com/in/muharremkoroglu/")
                )
            ]
        case .legal:
            return [
                SettingModel(
                    settingType: .privacyPolicy,
                    settingTitle: "Privacy Policy",
                    settingIcon: UIImage(systemName: "hand.raised"),
                    settingUrl: URL(string: "https://sites.google.com/view/purplai/privacy-policy")
                ),
                SettingModel(
                    settingType: .termsOfService,
                    settingTitle: "Terms of Service",
                    settingIcon: UIImage(systemName: "book"),
                    settingUrl: URL(string: "https://sites.google.com/view/purplai/terms-of-service")
                )
                
            ]
        case .contactUs:
            return [
                SettingModel(
                    settingType: .contactUs,
                    settingTitle: "Contact Us",
                    settingIcon: UIImage(systemName: "envelope"),
                    settingUrl: URL(string: "https://sites.google.com/view/purplai/contact")
                ),
            ]
        case .account:
            return [
                SettingModel(
                    settingType: .deleteMyAccount,
                    settingTitle: "Delete My Account",
                    settingIcon: UIImage(systemName: "trash"),
                    settingUrl: nil
                ),
                SettingModel(
                    settingType: .signOut,
                    settingTitle: "Sign Out",
                    settingIcon: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                    settingUrl: nil
                )
                
            ]
        }
  
    }
    
}
