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
    static let instance = WatsonAssistant()
    private let authenticator = WatsonIAMAuthenticator(apiKey: "S0y2Iqdb8Vaqcyi2FzA1phRkf3SQlIuDUCoxgvDTf9X6")
    private let assistant: Assistant
    private let assistantID = "55387256-c31a-49d1-874f-a561d449352d"
    private var context: MessageContextStateless = MessageContextStateless()

    init() {
        assistant = Assistant(version: "2021-09-30", authenticator: authenticator)
        assistant.serviceURL = "https://api.us-east.assistant.watson.cloud.ibm.com/instances/5103af21-a2a3-4c82-a103-feefd448a30f"
    }
}
