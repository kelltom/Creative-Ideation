//
//  ChatbotView.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-10-07.
//

import SwiftUI

struct ChatbotView: View {

    @Binding var showChatbot: Bool
    @State var input: String = ""
    @State var initialRequest: String = "Help"

    @EnvironmentObject var chatbotViewModel: ChatbotViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Title Bar
            HStack {
                Text("Help Centre")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Button {
                    withAnimation {
                        showChatbot = false
                    }
                } label: {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                        .padding(8)
                }
            }
            .padding()
            .background(Color("brandPrimary"))

            // Chat Area
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack {
                    ForEach(chatbotViewModel.chatlog.reversed()) { message in
                        MessageView(message: message)
                            .rotationEffect(Angle(degrees: 180))
                            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                            .animation(.easeInOut)
                            .padding(.top)
                    }
                }
            }
            .padding()
            .background(Color("BackgroundColor"))
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)

            // Input / Send Button
            HStack {
                if #available(iOS 15.0, *) {
                    TextField("Type your message...", text: $input)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: CGFloat(30))
                        .onSubmit {
                            chatbotViewModel.send(text: input)
                            input = ""
                        }
                        .submitLabel(.send)
                } else {
                    // Fallback on earlier versions
                    TextField("Type your message...", text: $input)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: CGFloat(30))
                }
                Button {
                    chatbotViewModel.send(text: input)
                    input = ""
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
            }
            .padding()
            .background(Color("BackgroundColor"))
        }
        .frame(width: 400, height: 500)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray)
        )
        .onAppear {
            chatbotViewModel.send(text: initialRequest)
        }
        .onDisappear {
            chatbotViewModel.chatlog = []
        }
    }
}

struct MessageView: View {

    let message: Message
    @EnvironmentObject var chatbotViewModel: ChatbotViewModel

    var body: some View {

        // Print options in a grid
        if message.messageType == .option && !message.options.isEmpty {
            let items: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
            LazyVGrid(columns: items) {
                ForEach(message.options, id: \.self) { optionText in
                    Button {
                        chatbotViewModel.send(text: optionText)
                    } label: {
                        Text(optionText)
                            .font(.caption)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(UIColor.lightGray))
                            .cornerRadius(5)
                    }
                }
            }
        }

        HStack {
            if message.status == .sent {
                Spacer()
            }
            Text(message.text)
                .padding()
                .foregroundColor(.white)
                .background(message.status == .sent ? Color.blue : Color.gray)
                .cornerRadius(15)
            if message.status == .received {
                Spacer()
            }
        }
    }
}

struct ChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotView(showChatbot: .constant(true))
            .environmentObject(ChatbotViewModel())
    }
}
