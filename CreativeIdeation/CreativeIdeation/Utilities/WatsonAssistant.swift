//
//  WatsonAssistant.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-09-30.
//

import Foundation
import AssistantV2

/// Allows for interfacing with IBM Watson Assistant
class WatsonAssistant {
    // Singleton used by views that need to interact with assistant
    static var instance = WatsonAssistant()
    private let authenticator = WatsonIAMAuthenticator(apiKey: "S0y2Iqdb8Vaqcyi2FzA1phRkf3SQlIuDUCoxgvDTf9X6")
    private let assistant: Assistant
    private let assistantID = "55387256-c31a-49d1-874f-a561d449352d"
    private var context: MessageContextStateless = MessageContextStateless()

    struct ChatbotResponse {
        var responseType: ResponseType
        var text: String
        var options: [String] = []

        enum ResponseType {
            case text, option
        }
    }

    private init() {
        assistant = Assistant(version: "2021-06-14", authenticator: authenticator)
        assistant.serviceURL = "https://api.us-east.assistant.watson.cloud.ibm.com/instances/5103af21-a2a3-4c82-a103-feefd448a30f"
    }

    /// Call this as async, get 'result in'. Check if case .success(let response):, then send that generic response to another function in here to process it and return to viewmodel
    func sendTextToAssistant(text: String, completion: @escaping(Result<MessageResponseStateless, WatsonError>) -> Void) {
        // Make input object with text to send
        let input = MessageInputStateless(messageType: "text", text: text)

        // Send message
        self.assistant.messageStateless(assistantID: self.assistantID, input: input, context: context) { (response, error) in

            // Retrieve result from assistant
            guard let result = response?.result else {
                if let error = error {
                    print("WatsonAssistant Error from Assistant: \(error.localizedDescription).")
                } else {
                    print("WatsonAssistant Error: Cannot get result object from response.")
                }
                completion(.failure(WatsonError.noResponse))
                return
            }

            // Update context to possibly continue conversation
            self.context = result.context

            completion(.success(result))
        }
    }

    /// This function takes a generic response, processes it, and returns the text representation.
    func processGenericResponse(assistantResponse: [RuntimeResponseGeneric]) -> ChatbotResponse {
        var chatbotResponse = ChatbotResponse(responseType: .text, text: "")
        for response in assistantResponse {
            switch response {
            case let .text(innerResponse):
                chatbotResponse.text = innerResponse.text
            case let .option(innerResponse):
                chatbotResponse.responseType = .option
                chatbotResponse.text = innerResponse.title
                // Extract options
                let options = innerResponse.options
                for option in options {
                    chatbotResponse.options.append(option.label)
                }
            default:
                chatbotResponse.text = "Unfortunately, I can't describe my response in words."
            }
        }
        return chatbotResponse
    }
}
