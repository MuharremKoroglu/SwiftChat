//
//  UserProfileModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 9.06.2024.
//

import Foundation

struct FirebaseUserModel : Codable{
    
    let profileImage : URL
    let userId : String
    let userName : String
    let userEmail : String
    let userPhoneNumber : String
    let accountCreatedDate : Date
    
    
    enum CodingKeys : String, CodingKey {
        
        case profileImage = "profile_image"
        case userId = "user_id"
        case userName = "user_name"
        case userEmail = "user_email"
        case userPhoneNumber = "user_phone_number"
        case accountCreatedDate = "account_created_date"
        
    }
    
    
}

