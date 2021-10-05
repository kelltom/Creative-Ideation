//
//  ChatbotViewModel.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-10-05.
//

import Foundation

final class ChatbotViewModel: ObservableObject {
    // Reference to singleton chatbot instance
    private let chatbot = WatsonAssistant.instance

    enum MessageStatus {
        case pending, sent, received
    }

    /// Chat log containing message history with chatbot in order (array of tuples)
    @Published var chatlog: [(status: MessageStatus, text: String)] = []

    /// Send message to chatbot and expect response
    func send(text: String) {

        // Append message to chat log
        chatlog.append((MessageStatus.sent, text))

        chatbot.sendTextToAssistant(text: text) { result in
            switch result {
            case .success(let response):
                if let generic = response.output.generic {
                    self.chatlog.append((MessageStatus.received,
                                         self.chatbot.processGenericResponse(assistantResponse: generic)))
                    print("chatbotViewModel: Send success")
                } else {
                    self.chatlog.append((MessageStatus.received, "Invalid response."))
                    print("chatbotViewModel: Invalid response")
                }

                print(self.chatlog)
            default:
                self.chatlog.append((MessageStatus.received, "Chatbot is offline. Try again later."))
                print("chatbotViewModel: Default")
            }
        }
    }
}
