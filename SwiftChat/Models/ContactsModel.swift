//
//  ContactsModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 13.06.2024.
//

import Foundation

struct ContactModel: Codable {
    let id: String
    let name: String
    let email: String
    let phone: String
    let profileImageURL: URL
}

extension ContactModel {
    init(from firebaseUser: FirebaseUserModel) {
        self.id = firebaseUser.userId
        self.name = firebaseUser.userName
        self.email = firebaseUser.userEmail
        self.phone = firebaseUser.userPhoneNumber
        self.profileImageURL = firebaseUser.profileImage
    }
}

extension ContactModel {
    init(from apiUser: APIUserInfo) {
        self.id = apiUser.login.uid
        self.name = "\(apiUser.name.first) \(apiUser.name.last)"
        self.email = apiUser.email
        self.phone = apiUser.phone
        self.profileImageURL = URL(string: apiUser.picture.large)!
    }
}

