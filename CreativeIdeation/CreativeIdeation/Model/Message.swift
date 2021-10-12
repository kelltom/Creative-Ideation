//
//  Message.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-10-07.
//

import Foundation

/// Chatbot message model
struct Message: Identifiable {
    var id = UUID()
    var messageType: MessageType
    var status: MessageStatus
    var text: String

    enum MessageType {
        case text, option
    }
    enum MessageStatus {
        case pending, sent, received
    }
}
