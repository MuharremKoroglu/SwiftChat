//
//  MessageModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 20.06.2024.
//

import Foundation

struct MessageModel : Codable {
    
    let senderId : String
    let receiverId : String
    let messageContent : String
    let messageDate : Date
    
    enum CodingKeys : String, CodingKey {
        
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case messageContent = "message_content"
        case messageDate = "message_date"
        
    }
    
}
