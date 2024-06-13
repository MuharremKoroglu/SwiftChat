//
//  ContactsRequestModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.05.2024.
//

import Foundation

struct APIUserRequestModel : Codable {
    
    let results : Int
    let include : String
    let nationality : String
    let noinfo : String
    
    enum CodingKeys : String, CodingKey {
        case results
        case include = "inc"
        case nationality = "nat"
        case noinfo
    }
    
}
