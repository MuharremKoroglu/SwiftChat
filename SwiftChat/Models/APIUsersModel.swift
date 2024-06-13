//
//  ContactsResponseModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.05.2024.
//

import Foundation

struct APIUsersModel: Codable {
    let results: [APIUserInfo]
}

struct APIUserInfo: Codable {
    let name: APIUserName
    let email : String
    let login : APIUserLoginDetails
    let phone: String
    let picture: APIUserPicture
}

struct APIUserLoginDetails : Codable {
    let uid : String
    
    enum CodingKeys : String, CodingKey {
        case uid = "uuid"
    }
    
}

struct APIUserName: Codable {
    let first, last: String
}

struct APIUserPicture: Codable {
    let large: String
}
