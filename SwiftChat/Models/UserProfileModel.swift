//
//  UserProfileModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 9.06.2024.
//

import Foundation

struct UserProfileModel : Codable{
    
    let profileImage : URL
    let userName : String
    let userEmail : String
    let accountCreatedDate : Date
    
    
    enum CodingKeys : String, CodingKey {
        
        case profileImage = "profile_image"
        case userName = "user_name"
        case userEmail = "user_email"
        case accountCreatedDate = "account_created_date"
        
    }
    
    
}

