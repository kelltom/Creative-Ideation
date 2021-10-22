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
    @State var showProfanity: Bool = true
    @State var showDashboard: Bool = true
    @State var chartData: [Double] = [3, 5, 6]
    let barStyle = ChartStyle(backgroundColor: .white,
                              foregroundColor: [ColorGradient(.green),
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

                        ScrollView {
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

                                Text("Number of Stickies for Round 2 of Voting")
                                    .padding()
                                    .padding(.bottom, -10)

                                HStack {

                                    Spacer()

                                    TextField("", text: $textTopStickies)
                                        .frame(width: 50)
                                        .multilineTextAlignment(.center)
                                        .padding(3)
                                        .overlay(RoundedRectangle(cornerRadius: 5).stroke())
                                        .keyboardType(.numberPad)
                                        .onReceive(Just(selectedTopStickies)) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue {
                                                self.selectedTopStickies = filtered
                                            }
                                        }

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
                                    .onChange(of: settings.filterProfanity, perform: { _ in
                                        sessionSettingsViewModel.toggleProfanity()
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
                                            .padding()
                                        Button {
                                            withAnimation {
                                                isCollapsed.toggle()
                                                sessionViewModel.getProfanityList(sessionMembers: groupViewModel.selectedGroup?.members ?? ["N/a"])
                                            }
                                        } label: {

                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(Color("StrokeColor"))
                                                .rotationEffect(Angle.degrees(isCollapsed ? 0 : 90))
                                                .animation(.easeInOut)

                                        }
                                    }

                                    // Export Data Options
                                    HStack {
                                        Spacer()
                                        Menu {
                                            HStack {
                                                Button {
                                                    // action
                                                    showDashboard.toggle()
                                                } label: {
                                                    if showDashboard {
                                                        Text("Show Dashboard")
                                                    } else {
                                                        Text("Hide Dashboard")
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
                                                .frame(width: 20, height: 25)
                                                .padding()
                                        }.foregroundColor(Color("StrokeColor"))
                                    }

                                }
                                // Profanity log list
                                if !isCollapsed {
                                    VStack {
                                        ScrollView {
                                            HStack {
                                                Text("Name")
                                                    .fontWeight(.bold)
                                                    .animation(.easeInOut)
                                                Spacer()
                                                Text("Profanity Count")
                                                    .fontWeight(.bold)
                                                    .animation(.easeInOut)
                                                    .padding()
                                            }
                                            .frame(width: geometry.size.width * 0.7)

                                            if sessionViewModel.profanityUsers.isEmpty {
                                                VStack {
                                                    Text("No Profanity Users")
                                                }
                                            } else {
                                                ForEach(sessionViewModel.profanityUsers, id: \.self) { user in
                                                    VStack {
                                                        HStack {
                                                            Text(user.name)
                                                                .animation(.easeInOut)
                                                            Spacer()
                                                            Text(String(user.profanityList.count))
                                                                .animation(.easeInOut)
                                                                .padding()
                                                        }
                                                        .padding(.top, 5)
                                                        .animation(.easeInOut)

                                                    }

                                                    if !showProfanity {
                                                        VStack {
                                                            HStack {
                                                                Text("Words: ")
                                                                    .fontWeight(.bold)
                                                                    .animation(.easeInOut)
                                                                ScrollView(.horizontal) {
                                                                    Text(user.profanityList.joined(separator: ", "))
                                                                        .animation(.easeInOut)
                                                                }

                                                            }
//                                                            .frame(width: geometry.size.width * 0.7, height:30)
                                                        }
                                                        .frame(width: geometry.size.width * 0.7, alignment: .leading)
                                                        .opacity(0.5)
                                                        .padding(.top, 4)

                                                    }
                                                    // Dashboard 
                                                    if !showDashboard {
                                                        CardView {
                                                            PieChart()
                                                            ChartLabel("Session Behaviour Summary", type: .legend)
                                                        }
                                                        .data([sessionViewModel.lengthOfTotalWordCount, sessionViewModel.lengthOfProfanityWords])
                                                        .chartStyle(self.barStyle)
                                                        .frame(width: geometry.size.width * 0.3, height: 250)
                                                        .padding()

                                                    }
                                                }

                                            }

                                        }
                                        .padding(5)
                                    }

                                }
                                Divider()
                                    .frame(width: geometry.size.width * 0.7)
                                    .background(Color("FadedColor"))
                                    .animation(.easeInOut)

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
