//
//  ChatModel.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 22.07.2024.
//

import Foundation

struct RecentMessageModel {
    
    let receiverProfile : ContactModel
    let recentMessageContent : String
    let recentMessageType : MessageType
    let recentMessageDate : Date
    
}
