//
//  SessionSettings.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-09-30.
//

import SwiftUI
import Combine
import GTMSessionFetcherCore
import SwiftUICharts

struct SessionSettingsSheet: View {

    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var sessionSettingsViewModel: SessionSettingsViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel

    @Binding var showSheet: SessionSheet?
    @Binding var settings: SessionSettings
    @Binding var textTime: String
    @Binding var textTopStickies: String

    @State private var selectedTime = "10"
    @State private var timeSelectionExpanded = false
    @State var isCollapsed: Bool = true
    @State var showProfanity: Bool = false
    @State var showGraph: Bool = false
    var numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    let pieStyle = ChartStyle(backgroundColor: Color("BackgroundColor"),
                              foregroundColor: [ColorGradient(.blue),
                                                ColorGradient(.red)])

    @State private var selectedTopStickies = "6"
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

                        ScrollView(showsIndicators: false) {
                            LazyVStack(alignment: .leading) {

                                Toggle("Display Timer", isOn: $settings.displayTimer)
                                    .padding()
                                    .padding(.bottom, -10)
                                    .onChange(of: settings.displayTimer, perform: { _ in
                                        sessionSettingsViewModel.toggleTimer()
                                    })

                                HStack {

                                    Spacer()

                                    Text("Time:")

                                    Picker("Time", selection: $textTime) {
                                        ForEach(numbers, id: \.self) {
                                            Text($0)
                                                .rotationEffect(.degrees(90))
                                        }
                                    }
                                    .frame(width: 90, height: 30)
                                    .rotationEffect(.degrees(-90))
                                    .pickerStyle(WheelPickerStyle())
                                    .compositingGroup()
                                    .clipped(antialiased: true)

                                    Text("minutes")

                                    Button {
                                        sessionSettingsViewModel.updateTime()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                            if !sessionViewModel.selectedSession!.timerActive {
                                                sessionViewModel.resetTimer(time: Int(sessionSettingsViewModel.textTime)! * 60)
                                            }
                                        }
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

                                Text("Number of Stickies for Round 2 of Voting")
                                    .padding()
                                    .padding(.bottom, -10)

                                HStack {

                                    Spacer()
                                    Text("Top")

                                    Picker("", selection: $textTopStickies) {
                                        ForEach(numbers[1..<10], id: \.self) {
                                            Text($0)
                                                .rotationEffect(.degrees(90))
                                        }
                                    }
                                    .frame(width: 90, height: 30)
                                    .pickerStyle(WheelPickerStyle())
                                    .rotationEffect(.degrees(-90))
                                    .compositingGroup()
                                    .clipped(antialiased: true)

                                    Text("stickies")

                                    Button {
                                        sessionSettingsViewModel.updateTopStickyCount()
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
                                    .onChange(of: settings.filterProfanity, perform: { filter in
                                        sessionSettingsViewModel.toggleProfanity()
                                        if !filter {
                                            isCollapsed = true
                                        }
                                    })

                                // Profanity Begins Here
                                Divider()
                                    .frame(width: geometry.size.width * 0.7)
                                    .background(Color("FadedColor"))

                                ZStack {
                                    HStack(spacing: 0) {
                                        Text("Profanity Log")
                                            .font(.title3)
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                            .foregroundColor(sessionSettingsViewModel.settings[1].filterProfanity ? Color("StrokeColor") : Color("FadedColor"))
                                            .padding()
                                        Button {
                                            withAnimation {
                                                isCollapsed.toggle()
                                                sessionViewModel.getProfanityList(sessionMembers: groupViewModel.selectedGroup?.members ?? ["N/a"])
                                                sessionViewModel.getGraphData()
                                            }
                                        } label: {
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 40, height: 15)
                                                .foregroundColor(sessionSettingsViewModel.settings[1].filterProfanity ? Color("StrokeColor") : Color("FadedColor"))
                                                .rotationEffect(Angle.degrees(isCollapsed ? 0 : 90))
                                                .animation(.easeInOut)
                                        }
                                        .disabled(sessionSettingsViewModel.settings[1].filterProfanity == false)
                                    }

                                    // Export Data Options
                                    HStack {
                                        Spacer()
                                        Menu {
                                            HStack {
                                                Button {
                                                    // action
                                                    showGraph.toggle()
                                                } label: {
                                                    if showGraph {
                                                        Text("Show Graph")
                                                    } else {
                                                        Text("Hide Graph")
                                                    }
                                                }
                                            }

                                            Button {
                                                withAnimation {showProfanity.toggle()}
                                            } label: {
                                                if showProfanity {
                                                    Text("Show Profanity")
                                                } else {
                                                    Text("Hide Profanity")
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(sessionSettingsViewModel.settings[1].filterProfanity ? Color("StrokeColor") : Color("FadedColor"))
                                                .frame(width: 20, height: 25)
                                                .padding()
                                        }
                                        .disabled(!sessionSettingsViewModel.settings[1].filterProfanity)
                                    }
                                }
                                // Profanity log list
                                if !isCollapsed {
                                    VStack {
                                        ScrollView(showsIndicators: false) {
                                            HStack {
                                                Text("Name")
                                                    .fontWeight(.bold)
                                                    .animation(.easeInOut)
                                                Spacer()
                                                Text("Profanity Count")
                                                    .fontWeight(.bold)
                                                    .animation(.easeInOut)
                                                    .padding(.horizontal, 2)
                                            }
                                            .frame(width: geometry.size.width * 0.7)

                                            if sessionViewModel.profanityUsers.isEmpty {
                                                VStack {
                                                    Text("No Profanity Users")
                                                }
                                            } else {
                                                ForEach(sessionViewModel.profanityUsers, id: \.self) { user in
                                                    HStack {
                                                        Text(user.name)
                                                            .animation(.easeInOut)
                                                        Spacer()
                                                        Text(String(user.profanityList.count))
                                                            .animation(.easeInOut)
                                                            .padding()
                                                    }
                                                    .padding(.bottom, -20)
                                                    .animation(.easeInOut)

                                                    if !showProfanity {
                                                        HStack {
                                                            Text("Words: ")
                                                                .fontWeight(.bold)
                                                                .animation(.easeInOut)
                                                            ScrollView(.horizontal, showsIndicators: false) {
                                                                Text(user.profanityList.joined(separator: ", "))
                                                                    .animation(.easeInOut)
                                                            }

                                                        }
                                                        .frame(width: geometry.size.width * 0.7, alignment: .leading)
                                                        .opacity(0.5)
                                                    }
                                                }

                                                // Pie Graph
                                                if !showGraph {

                                                    Text("Session Behaviour Summary Graph")
                                                        .foregroundColor(sessionSettingsViewModel.settings[1].filterProfanity ? Color("StrokeColor") : Color("FadedColor"))
                                                        .font(.title3)
                                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                        .padding(.top, 8)

                                                    HStack {
                                                        VStack(alignment: .leading) {
                                                            HStack {
                                                                Rectangle()
                                                                    .fill(Color.blue)
                                                                    .frame(width: 10, height: 10)
                                                                Text("Good - \(String(format: "%.0f", sessionViewModel.lengthOfTotalWordCount))")
                                                            }

                                                            HStack {
                                                                Rectangle()
                                                                    .fill(Color.red)
                                                                    .frame(width: 10, height: 10)
                                                                Text("Bad - \(String(format: "%.0f", sessionViewModel.lengthOfProfanityWords))")

                                                            }

                                                        }
                                                        .frame(width: geometry.size.width * 0.2, height: 20)

                                                        CardView {
                                                            PieChart()
                                                                .padding()

                                                        }
                                                        .data([sessionViewModel.lengthOfTotalWordCount, sessionViewModel.lengthOfProfanityWords])
                                                        .chartStyle(self.pieStyle)
                                                        .frame(width: geometry.size.width * 0.45, height: 300)
                                                        .padding()
                                                    }
                                                }

                                            }

                                        }
                                        .padding(2)
                                    }

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
        SessionSettingsSheet(showSheet: .constant(.settings), settings: .constant(SessionSettings()), textTime: .constant("10"), textTopStickies: .constant("6"))
            .environmentObject(SessionViewModel())
            .environmentObject(GroupViewModel())
    }
}
