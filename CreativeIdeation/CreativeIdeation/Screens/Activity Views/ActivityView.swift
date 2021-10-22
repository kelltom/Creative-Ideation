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

    let colorArray = [Color.init(red: 0.9, green: 0, blue: 0),
                      Color.init(red: 0.9, green: 0.6, blue: 0),
                      Color.init(red: 0, green: 0.9, blue: 0),
                      Color.init(red: 0, green: 0.7, blue: 0.9),
                      Color.init(red: 0.9, green: 0.45, blue: 0.9)]

    let columns = [
        GridItem(.adaptive(minimum: 160))]

    @ObservedObject var timerManager: TimerManager

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

    @Binding var showActivity: Bool

    var body: some View {
        ZStack {

            Color("BackgroundColor")

            VStack {
                HStack {

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
                                .frame(width: 80, height: 80)

                            Circle().stroke(lineWidth: 2)
                                .foregroundColor(Color("StrokeColor"))
                                .frame(width: 80, height: 80)

                            Image(systemName: "arrow.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color("StrokeColor"))
                        }
                        .frame(width: 85, height: 85)
                        .clipped()
                        .padding(.leading, 45)
                        .padding(.top, 20)
                        .shadow(radius: 4, y: 4)
                    }

                    Text(sessionViewModel.selectedSession?.sessionTitle ?? "Loading...")
                        .font(.system(size: 48, weight: .heavy))
                        .padding()

                    Button {
                        infoPopover.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
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

                    Spacer()

                    if groupViewModel.isCurrentUserAdmin(groupId: groupViewModel.selectedGroup?.groupId ?? "no ID") && sessionViewModel.selectedSession?.stage ?? 1 != 4 {
                        Button {
                            withAnimation {
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
                            Text("Next Stage...")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .padding(10)
                                .background(Color.red)
                                .cornerRadius(12)
                                .shadow(radius: 4, y: 4)
                                .padding(.trailing)
                        }
                    }

                    // Settings gear button for Session Preferences
                    if groupViewModel.isCurrentUserAdmin(groupId: groupViewModel.selectedGroup?.groupId ?? "no ID") {
                        Button {
                            showSheet = .settings
                            
                        } label: {
                            Image("settings")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .padding(.trailing, 30)
                                .shadow(radius: 4)
                        }
                    }
                }

                if sessionViewModel.selectedSession?.stage == 1 {
                    HStack {
                        Menu {
                            Button("Alphabetically", action: { sessionItemViewModel.sortStickies(sortBy: .alphabetical)})
                            Button("By Color", action: { sessionItemViewModel.sortStickies(sortBy: .color)})
                            Button("By Score", action: { sessionItemViewModel.sortStickies(sortBy: .score)})
                        } label: {
                            Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                        }
                        .font(.largeTitle)
                        .foregroundColor(Color("StrokeColor"))
                        .padding(.leading)
                        .padding(.top, 12)

                        Spacer()

                        if sessionSettingsViewModel.settings.last!.displayTimer {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(lineWidth: 3)
                                        .frame(width: 120, height: 70)
                                        .padding(.trailing)

                                    Text(timerManager.toString())
                                        .font(.largeTitle)
                                        .padding(.trailing)
                                }

                                if groupViewModel.isCurrentUserAdmin(groupId: groupViewModel.selectedGroup?.groupId ?? "no ID") {
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
                                            .padding(.trailing)
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
                                    }
                                }
                            }
                            .padding(.top)
                        }

                        Spacer()
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

                        VStack(alignment: .trailing) {
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

                            VStack(spacing: 10) {
                                HStack(spacing: 10) {
                                    Button {
                                        if sessionItemViewModel.selectedSticky != nil {
                                            sessionItemViewModel.colorSelected(color: 0)
                                            sessionViewModel.updateDateModified()
                                        } else {
                                            selectedColor = 0
                                            randomizeColor = false
                                        }

                                    } label: {
                                        ZStack {
                                            Circle()
                                                .fill(colorArray[0])
                                                .frame(width: 25, height: 25)
                                            if selectedColor == 0 {
                                                Circle()
                                                    .stroke(Color("BackgroundColor"), lineWidth: 2)
                                                    .frame(width: 19, height: 19)
                                            }
                                        }
                                    }

                                    Button {
                                        if sessionItemViewModel.selectedSticky != nil {
                                            sessionItemViewModel.colorSelected(color: 1)
                                            sessionViewModel.updateDateModified()
                                        } else {
                                            selectedColor = 1
                                            randomizeColor = false
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .fill(colorArray[1])
                                                .frame(width: 25, height: 25)
                                            if selectedColor == 1 {
                                                Circle()
                                                    .stroke(Color("BackgroundColor"), lineWidth: 2)
                                                    .frame(width: 19, height: 19)
                                            }
                                        }
                                    }
                                }
                                HStack(spacing: 10) {
                                    Button {
                                        if sessionItemViewModel.selectedSticky != nil {
                                            sessionItemViewModel.colorSelected(color: 2)
                                            sessionViewModel.updateDateModified()
                                        } else {
                                            selectedColor = 2
                                            randomizeColor = false
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .fill(colorArray[2])
                                                .frame(width: 25, height: 25)
                                            if selectedColor == 2 {
                                                Circle()
                                                    .stroke(Color("BackgroundColor"), lineWidth: 2)
                                                    .frame(width: 19, height: 19)
                                            }
                                        }
                                    }

                                    Button {
                                        if sessionItemViewModel.selectedSticky != nil {
                                            sessionItemViewModel.colorSelected(color: 3)
                                            sessionViewModel.updateDateModified()
                                        } else {
                                            selectedColor = 3
                                            randomizeColor = false
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .fill(colorArray[3])
                                                .frame(width: 25, height: 25)
                                            if selectedColor == 3 {
                                                Circle()
                                                    .stroke(Color("BackgroundColor"), lineWidth: 2)
                                                    .frame(width: 19, height: 19)
                                            }
                                        }
                                    }
                                }
                                HStack(spacing: 10) {
                                    Button {
                                        if sessionItemViewModel.selectedSticky != nil {
                                            sessionItemViewModel.colorSelected(color: 4)
                                            sessionViewModel.updateDateModified()
                                        } else {
                                            selectedColor = 4
                                            randomizeColor = false
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .fill(colorArray[4])
                                                .frame(width: 25, height: 25)
                                            if selectedColor == 4 {
                                                Circle()
                                                    .stroke(Color("BackgroundColor"), lineWidth: 2)
                                                    .frame(width: 19, height: 19)
                                            }
                                        }
                                    }
                                }

                                Button {
                                    if sessionItemViewModel.selectedSticky == nil {
                                        // randomize button
                                        if !randomizeColor {
                                            selectedColor = -1
                                            randomizeColor = true
                                        }

                                    } else {
                                        // confirm button, deselect
                                        sessionItemViewModel.updateItem(itemId: sessionItemViewModel.selectedItem!.itemId)
                                        sessionItemViewModel.clearSelected()
                                        sessionViewModel.updateDateModified()
                                    }
                                } label: {
                                    if sessionItemViewModel.selectedSticky == nil {
                                        ZStack {
                                            Image(systemName: "questionmark")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 15, height: 15)
                                                .foregroundColor(randomizeColor ? Color.white : Color.black)
                                                .frame(width: 60, height: 30)
                                                .background(randomizeColor ? Color.black : Color.white)
                                                .cornerRadius(5)
                                                .padding(.top, 5)

                                            if randomizeColor {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color("BackgroundColor"), lineWidth: 2)
                                                    .frame(width: 54, height: 24)
                                                    .padding(.top, 5)
                                            } else {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.black, lineWidth: 2)
                                                    .frame(width: 60, height: 30)
                                                    .padding(.top, 5)
                                            }
                                        }
                                    } else {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.white)
                                            .frame(width: 60, height: 30)
                                            .background(Color.green)
                                            .cornerRadius(5)
                                            .padding(.top, 5)
                                    }
                                }

                                Button {
                                    if sessionItemViewModel.selectedSticky != nil {
                                        // delete button
                                        sessionItemViewModel.deleteSelected()
                                        sessionViewModel.updateDateModified()
                                    }
                                } label: {
                                    Image(systemName: "trash.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                        .frame(width: 60, height: 30)
                                        .background(Color.red)
                                        .opacity(sessionItemViewModel.selectedSticky != nil ? 1 : 0.5)
                                        .cornerRadius(5)
                                }
                                .disabled(sessionItemViewModel.selectedSticky == nil)
                            }
                            .frame(minWidth: 80, minHeight: 200)
                            .background(Color("BackgroundColor"))
                            .clipped()
                            .cornerRadius(15)
                            .shadow(radius: 6, y: 4)
                            .padding(.trailing, 21)

                            HStack {
                                // AI Word Generation button
                                Button {
                                    sessionItemViewModel.clearIdeas()
                                    ideasIndex = 0
                                    sessionItemViewModel.generateIdeas()
                                    aiPopover = true
                                } label: {
                                    Image("brainwriting")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 90, height: 90)
                                        .padding(.top, 8)
                                        .shadow(radius: 4, y: 4)
                                }
                                .padding(.trailing)
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
                                                UIPasteboard.general.string =
                                                    sessionItemViewModel.generatedIdeas[ideasIndex]
                                            } label: {
                                                Image(systemName: "doc.on.doc")
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
