//
//  ActivityView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI
import PencilKit

enum SessionSheet: Identifiable {
    case settings

    var id: Int {
        hashValue
    }
}

struct ActivityView: View {

    @EnvironmentObject var sessionItemViewModel: SessionItemViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var sessionSettingsViewModel: SessionSettingsViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel
    @Environment(\.colorScheme) var colorScheme

    let colorArray = [Color.init(red: 0.9, green: 0, blue: 0),
                      Color.init(red: 0.9, green: 0.6, blue: 0),
                      Color.init(red: 0, green: 0.9, blue: 0),
                      Color.init(red: 0, green: 0.7, blue: 0.9),
                      Color.init(red: 0.9, green: 0.45, blue: 0.9)]

    let columns = [
        GridItem(.adaptive(minimum: 160))]

    @ObservedObject var timerManager: TimerManager

    @State var showChatbot: Bool = false
    @State var showSheet: SessionSheet?
    @State var bounces: Int = 0

    @State var newColor: Int = 1
    @State private var selectedColor = -1
    @State private var randomizeColor: Bool = true

    @State private var ideas: [String] = []
    @State private var ideasIndex = 0
    @State private var idea = ""

    @State var aiPopover = false
    @State var infoPopover = false
    @State var newStickyPopover = false
    @State var timerPopover = false

    @Binding var showActivity: Bool

    var body: some View {
        ZStack {

            Color("BackgroundColor").zIndex(0)

            VStack(spacing: 0) {
                HStack(alignment: .center) {

                    Button {
                        showActivity = false
                        sessionItemViewModel.resetModel()
                        sessionViewModel.selectedSession = nil
                        sessionSettingsViewModel.clear()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            sessionViewModel.timerManager.pause()
                            sessionViewModel.timerManager = TimerManager()
                        }

                    } label: {
                        ZStack {
                            Circle()
                                .foregroundColor(Color("BackgroundColor"))
                                .frame(width: 50, height: 50)

                            Circle().stroke(lineWidth: 2)
                                .foregroundColor(Color("StrokeColor"))
                                .frame(width: 50, height: 50)

                            Image(systemName: "arrow.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color("StrokeColor"))
                        }
                        .frame(width: 55, height: 55)
                        .clipped()
                        .padding()
                        .shadow(radius: 4, y: 4)
                    }

                    Text(sessionViewModel.selectedSession?.sessionTitle ?? "Loading...")
                        .font(.system(size: 40, weight: .heavy))
                        .padding()

                    Button {
                        infoPopover.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color("StrokeColor"))
                    }
                    .popover(isPresented: $infoPopover, arrowEdge: .bottom) {
                        if sessionViewModel.selectedSession?.sessionDescription == "" {
                            Text("No Description")
                                .font(.title2)
                                .padding()
                        } else {
                            VStack {
                                Text(sessionViewModel.selectedSession?.sessionDescription ?? "No Description")
                                    .font(.title2)
                                    .frame(maxWidth: 400)
                                    .padding()
                            }
                        }
                    }

                    // Settings gear button for Session Preferences
                    if groupViewModel.isCurrentUserAdmin(groupId: groupViewModel.selectedGroup?.groupId ?? "no ID") {
                        Button {
                            showSheet = .settings

                        } label: {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color("StrokeColor"))
                                .frame(width: 35, height: 35)
                                .padding()
                                .shadow(radius: 4, y: 4)
                        }
                    }

                    Spacer()

                    if groupViewModel.isCurrentUserAdmin(groupId: groupViewModel.selectedGroup?.groupId ?? "no ID") && sessionViewModel.selectedSession?.stage ?? 1 != 4 {
                        Button {
                            withAnimation(.easeInOut) {
                                if sessionViewModel.selectedSession?.stage ?? 1 == 1 {
                                    if timerManager.mode == .running {
                                        sessionViewModel.toggleTimer(timeRemaining: Double(timerManager.timeRemaining))
                                    }
                                    sessionViewModel.beginVoting()
                                } else if sessionViewModel.selectedSession!.stage == 2 {
                                    sessionViewModel.finishVoting()
                                    sessionItemViewModel.finishVoting(spots: sessionSettingsViewModel.settings[1].topStickiesCount)
                                } else if sessionViewModel.selectedSession!.stage == 3 {
                                    sessionViewModel.finishTopVoting()
                                }
                            }
                        } label: {
                            HStack {
                                Text("Proceed")
                                    .font(.title)
                                    .foregroundColor(Color.white)
                                    .padding(.trailing, 8)

                                Image(systemName: "chevron.right.2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.white)
                            }
                            .padding(10)
                            .background(Color.green)
                            .cornerRadius(12)
                            .shadow(radius: 4, y: 4)
                            .padding(.trailing)
                        }
                    }
                }
                .padding(8)
                .padding(.bottom, -5)

                if sessionViewModel.selectedSession?.stage == 1 {
                    HStack(alignment: .center) {
                        ZStack {
                            if sessionSettingsViewModel.settings.last!.displayTimer {
                                HStack {

                                    Spacer()

                                    if groupViewModel.isCurrentUserAdmin(groupId: groupViewModel.selectedGroup?.groupId ?? "no ID") {
                                        Button {
                                            timerPopover = true
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(lineWidth: 3)
                                                    .frame(width: 120, height: 70)
                                                    .padding(.horizontal)

                                                Text(timerManager.toString())
                                                    .font(.largeTitle)
                                                    .padding(.horizontal)
                                                    .foregroundColor(Color("StrokeColor"))
                                            }
                                        }
                                        .popover(isPresented: $timerPopover, arrowEdge: .bottom) {
                                            HStack {
                                                Button {
                                                    if timerManager.timeRemaining == 0 {
                                                        timerManager.reset(newTime: sessionSettingsViewModel.settings[1].timerSetting)
                                                    }
                                                    sessionViewModel.toggleTimer(timeRemaining: Double(timerManager.timeRemaining))
                                                } label: {
                                                    Image(systemName: timerManager.mode == .running ? "pause.fill" : "play.fill")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 35, height: 35)
                                                        .foregroundColor(timerManager.mode == .running ? .blue : .green)
                                                        .padding()
                                                        .padding(.trailing, -8)
                                                }

                                                Button {
                                                    if !(timerManager.mode == .running) {
                                                        sessionViewModel.resetTimer(time: sessionSettingsViewModel.settings[1].timerSetting)
                                                    }
                                                } label: {
                                                    Image(systemName: "gobackward")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 40, height: 40)
                                                        .font(Font.title.weight(.bold))
                                                        .foregroundColor(timerManager.mode == .running ? Color("FadedColor") : .red)
                                                        .padding()
                                                        .padding(.leading, -8)
                                                }
                                            }
                                        }
                                    } else {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(lineWidth: 3)
                                                .frame(width: 120, height: 70)
                                                .padding(.horizontal)

                                            Text(timerManager.toString())
                                                .font(.largeTitle)
                                                .padding(.horizontal)
                                                .foregroundColor(Color("StrokeColor"))
                                        }
                                    }
                                    Spacer()
                                }
                            }

                            Spacer()
                        }
                        .padding(8)
                        .padding(.bottom, -5)
                    }

                    HStack(spacing: 0) {

                        // Display the stickies
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: columns, spacing: 25) {
                                ForEach(sessionItemViewModel.stickyNotes) { note in
                                    note
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 18)
                            .padding(.leading, 10)
                        }

                        VStack {
                            Button {
                                newColor = randomizeColor ? Int.random(in: 0..<5) : selectedColor
                                newStickyPopover = true

                            } label: {
                                VStack(spacing: 0) {
                                    Rectangle()
                                        .foregroundColor((selectedColor != -1) ?
                                                            colorArray[selectedColor].darker(by: 10) :
                                                            colorArray[0].darker(by: 10))
                                        .frame(width: 90, height: 20)

                                    Image(systemName: "plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                                        .frame(width: 90, height: 70)
                                        .background((selectedColor != -1) ?
                                                        colorArray[selectedColor] :
                                                        colorArray[0])
                                }
                                .cornerRadius(18)
                                .shadow(radius: 6, y: 4)
                                .padding()
                            }
                            .popover(isPresented: $newStickyPopover, arrowEdge: .leading) {
                                CreateStickyView(newStickyPopover: $newStickyPopover, chosenColor: newColor)
                            }

                            Menu {
                                Button("Sort Alphabetically", action: { sessionItemViewModel.sortStickies(sortBy: .alphabetical)})
                                Button("Sort by Color", action: { sessionItemViewModel.sortStickies(sortBy: .color)})
                            } label: {
                                Image(systemName: "arrow.up.arrow.down.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 65, height: 65)
                                    .foregroundColor(Color("StrokeColor"))
                            }
                            .padding(.top)
                            .foregroundColor(Color("StrokeColor"))

                            // AI Word Generation button
                            Button {
                                sessionItemViewModel.clearIdeas()
                                ideasIndex = 0
                                sessionItemViewModel.generateIdeas()
                                aiPopover = true
                            } label: {
                                ZStack {
                                    Image(systemName: "lightbulb")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 75, height: 75)
                                        .foregroundColor(Color("StrokeColor"))

                                    Image(systemName: "questionmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(Color("StrokeColor"))
                                        .padding(.bottom, 16)
                                }
                                .clipped()
                                .shadow(radius: 4, y: 4)
                            }
                            .popover(isPresented: $aiPopover, arrowEdge: .leading) {
                                if sessionItemViewModel.generatedIdeas.count > 0 {
                                    HStack {
                                        // Cycle left
                                        Button {
                                            if ideasIndex > 0 {
                                                ideasIndex -= 1
                                            } else {
                                                ideasIndex = sessionItemViewModel.generatedIdeas.count - 1
                                            }
                                            idea = sessionItemViewModel.generatedIdeas[ideasIndex]
                                        } label: {
                                            Image(systemName: "chevron.left")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(Color("StrokeColor"))
                                        }

                                        // Idea Text
                                        Text(sessionItemViewModel.generatedIdeas[ideasIndex])
                                            .font(.title2)
                                            .frame(width: 160)

                                        Button {
                                            sessionItemViewModel.createItem(color: Int.random(in: 0..<5), input: sessionItemViewModel.generatedIdeas[ideasIndex], filterProfanity: sessionSettingsViewModel.settings[1].filterProfanity)
                                            if ideasIndex > 0 {
                                                ideasIndex -= 1
                                                sessionItemViewModel.generatedIdeas.remove(at: ideasIndex + 1)
                                            } else {
                                                sessionItemViewModel.generatedIdeas.remove(at: ideasIndex)
                                                if sessionItemViewModel.generatedIdeas.count == 0 {
                                                    aiPopover = false
                                                }
                                            }
                                            sessionViewModel.updateDateModified()
                                        } label: {
                                            Image(systemName: "plus.square.fill.on.square.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(Color("StrokeColor"))
                                        }

                                        // Cycle right
                                        Button {
                                            if ideasIndex < sessionItemViewModel.generatedIdeas.count - 1 {
                                                ideasIndex += 1
                                            } else {
                                                ideasIndex = 0
                                            }
                                            idea = sessionItemViewModel.generatedIdeas[ideasIndex]
                                        } label: {
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(Color("StrokeColor"))
                                        }
                                    }
                                    .padding(10)
                                    .clipped()
                                    .cornerRadius(15)
                                    .shadow(radius: 4, y: 4)
                                }
                            }
                            .padding(.top)

                            Spacer()
                        }
                    }
                    .animation(.easeInOut)
                }

                // Voting Stage
                else if sessionViewModel.selectedSession?.stage == 2 {
                    VotingView(selectedSession: $sessionViewModel.selectedSession)
                        .animation(.easeInOut)
                } else if sessionViewModel.selectedSession?.stage == 3 {
                    TopVotedView()
                        .animation(.easeInOut)
                } else if sessionViewModel.selectedSession?.stage == 4 {
                    BestIdeaView(bestIdeas: $sessionItemViewModel.bestIdeas)
                        .animation(.easeInOut)
                }
            }
            .sheet(item: $showSheet) { item in
                switch item {
                case .settings:
                    SessionSettingsSheet(showSheet: $showSheet, settings: $sessionSettingsViewModel.settings[1], textTime: $sessionSettingsViewModel.textTime, textTopStickies: $sessionSettingsViewModel.textTopStickies)
                        .environmentObject(self.sessionViewModel)
                }
            }

            // Chatbot
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if showChatbot {
                        // Actual Chatbot
                        ChatbotView(showChatbot: $showChatbot)
                            .padding(20)
                            .animation(.easeInOut)
                    } else {
                        // Chatbot Button
                        Button {
                            withAnimation {
                                showChatbot = true
                            }
                        } label: {
                            Image(systemName: "questionmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(colorScheme == .dark ? .blue.lighter(by: 20) : .blue)
                                .frame(width: 60, height: 60)
                                .clipped()
                                .padding(20)
                        }
                    }
                }
            }
        }
        .navigationTitle("Session")
        .navigationBarHidden(true)
        .onAppear {
            if sessionViewModel.selectedSession!.timerActive {
                sessionViewModel.getRemainingTime(endTime: sessionViewModel.selectedSession!.timerEnd)
                sessionViewModel.timerManager.start()
            } else {
                sessionViewModel.timerManager.timeRemaining = sessionViewModel.selectedSession!.timeRemaining
            }
        }
        .onChange(of: timerManager.mode, perform: { mode in
            if mode == .finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        sessionViewModel.beginVoting()
                    }
                }
                sessionViewModel.toggleTimer(timeRemaining: Double(timerManager.timeRemaining))
            }
        })
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(timerManager: TimerManager(), showActivity: .constant(true))
            .environmentObject(SessionItemViewModel())
            .environmentObject(SessionViewModel())
            .environmentObject(GroupViewModel())
    }
}

// swiftlint:disable large_tuple
// swiftlint:disable identifier_name
// From: https://stackoverflow.com/questions/38435308/get-lighter-and-darker-color-variations-for-a-given-uicolor
extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }
        return (r, g, b, o)
    }

    func lighter(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> Color {
        return Color(red: min(Double(self.components.red + percentage/100), 1.0),
                     green: min(Double(self.components.green + percentage/100), 1.0),
                     blue: min(Double(self.components.blue + percentage/100), 1.0),
                     opacity: Double(self.components.opacity))
    }
}
