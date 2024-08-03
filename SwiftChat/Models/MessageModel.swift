//
//  MessageModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 20.06.2024.
//

import Foundation

struct MessageModel : Codable {
    
    let messageId : String
    let senderId : String
    let receiverId : String
    let messageContent : String
    let messageDate : Date
    let messageType : MessageType
    
    enum CodingKeys : String, CodingKey {
        
        case messageId = "message_id"
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case messageContent = "message_content"
        case messageDate = "message_date"
        case messageType = "message_type"
        
    }
    
}

enum MessageType: String, Codable {
    case text
    case media
}
