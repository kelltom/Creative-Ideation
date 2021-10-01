//
//  SessionSettings.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-09-30.
//

import SwiftUI
import Combine
import GTMSessionFetcherCore

struct SessionSettingsSheet: View {

    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var sessionSettingsViewModel: SessionSettingsViewModel

    @Binding var showSheet: SessionSheet?
    @Binding var settings: SessionSettings
    @Binding var textTime: String
    @Binding var textScore: String

    @State private var selectedTime = "10"
    @State private var timeSelectionExpanded = false

    @State private var selectedScore = "0"
    @State private var scoreSelectionExpanded = false

    var body: some View {

        ZStack {
            // Exit button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showSheet = nil
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(.label))
                            .imageScale(.large)
                            .frame(width: 80, height: 80)
                    }
                }
                .padding()
                Spacer()
            }

            GeometryReader { geometry in
                ZStack {

                    Color("BackgroundColor")

                    VStack(alignment: .center) {

                        Text("Settings")
                            .font(.system(size: 40, weight: .heavy))
                            .padding(.top, geometry.size.height * 0.1)

                        ScrollView {
                            LazyVStack {

                                Toggle("Display Timer", isOn: $settings.displayTimer)
                                    .padding()
                                    .padding(.bottom, -10)
                                    .onChange(of: settings.displayTimer, perform: { _ in
                                        sessionSettingsViewModel.toggleTimer()
                                    })

                                HStack {

                                    Spacer()

                                    Text("Time:")

                                    TextField("", text: $textTime)
                                        .frame(width: 50)
                                        .multilineTextAlignment(.center)
                                        .padding(3)
                                        .overlay(RoundedRectangle(cornerRadius: 5).stroke())
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(selectedTime)) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue {
                                                self.selectedTime = filtered
                                            }
                                        }

                                    Text("minutes")

                                    Button {
                                        sessionSettingsViewModel.updateTime()
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundColor(.green)

                                            Text("Save")
                                                .foregroundColor(.white)
                                                .padding(3)
                                        }
                                        .frame(width: 55)
                                    }
                                }
                                .padding(.trailing)

                                Toggle("Display Score After Voting", isOn: $settings.displayScore)
                                    .padding()
                                    .onChange(of: settings.displayScore, perform: { _ in
                                        sessionSettingsViewModel.toggleScore()
                                    })

                                Toggle("Delete Stickies Under Score Threshold", isOn: $settings.deleteStickies)
                                    .padding()
                                    .padding(.bottom, -10)
                                    .onChange(of: settings.deleteStickies, perform: { _ in
                                        sessionSettingsViewModel.toggleDelete()
                                    })

                                HStack {

                                    Spacer()

                                    Text("Score:")

                                    TextField("", text: $textScore)
                                        .frame(width: 50)
                                        .multilineTextAlignment(.center)
                                        .padding(3)
                                        .overlay(RoundedRectangle(cornerRadius: 5).stroke())
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(selectedScore)) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue {
                                                self.selectedScore = filtered
                                            }
                                        }

                                    Text("points")

                                    Button {
                                        sessionSettingsViewModel.updateScoreThreshold()
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundColor(.green)

                                            Text("Save")
                                                .foregroundColor(.white)
                                                .padding(3)
                                        }
                                        .frame(width: 55)
                                    }
                                }
                                .padding(.trailing)

                                Toggle("Filter Profanity", isOn: $settings.filterProfanity)
                                    .padding()
                                    .onChange(of: settings.filterProfanity, perform: { _ in
                                        sessionSettingsViewModel.toggleProfanity()
                                    })

                                // Profanity Begins Here
                                Divider()
                                    .frame(width: geometry.size.width * 0.7)
                                    .background(Color("FadedColor"))

                                Text("Profanity Log")
                                    .font(.title3)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .padding(.top)
                                    .padding()

                                List {
                                    Text("test")
                                    Text("test1")
                                    Text("test1")
                                }

                                Divider()
                                    .frame(width: geometry.size.width * 0.7)
                                    .background(Color("FadedColor"))

                            }
                            .frame(width: geometry.size.width * 0.7)
                        }

                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
}

struct SessionSettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SessionSettingsSheet(showSheet: .constant(.settings), settings: .constant(SessionSettings()), textTime: .constant("10"), textScore: .constant("0"))
            .environmentObject(SessionViewModel())
    }
}
