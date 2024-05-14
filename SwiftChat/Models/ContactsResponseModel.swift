//
//  ContactsResponseModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.05.2024.
//

import Foundation

struct ContactsResponseModel: Codable {
    let results: [ContactInfo]
}

struct ContactInfo: Codable {
    let name: ContactName
    let phone: String
    let picture: ContactPicture
}

struct ContactName: Codable {
    let title, first, last: String
}

struct ContactPicture: Codable {
    let large, medium, thumbnail: String
}
