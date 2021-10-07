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
    var status: MessageStatus
    var text: String

    enum MessageStatus {
        case pending, sent, received
    }
}
