//
//  ActivityView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI
import PencilKit

enum SessionSheet: Identifiable {
    case voting
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
    
    @State private var selectedColor = -1
    @State private var randomizeColor: Bool = true
    
    @State private var ideas: [String] = []
    @State private var ideasIndex = 0
    @State private var idea = ""
    @State private var isBouncing = false
    
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
                    
                    Spacer()
                    
                    if sessionSettingsViewModel.settings.last!.displayTimer {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 3)
                                    .frame(width: 140, height: 80)
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
                                        .frame(width: 40, height: 40)
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
                                        .frame(width: 45, height: 45)
                                        .font(Font.title.weight(.bold))
                                        .foregroundColor(timerManager.mode == .running ? Color("FadedColor") : .red)
                                }
                            }
                        }
                        .padding(.top)
                    }
                    
                    Spacer()
                }

                HStack {
                    Menu {
                        Button("Alphabetically", action: { sessionItemViewModel.sortStickies(sortBy: .alphabetical)})
                        Button("By Color", action: { sessionItemViewModel.sortStickies(sortBy: .color)})
                        Button("By Score", action: { sessionItemViewModel.sortStickies(sortBy: .score)})
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                    }
                    .font(.title)
                    .foregroundColor(Color("StrokeColor"))
                    .padding(.leading)
                    .padding(.top, 5)

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
                            let newColor = randomizeColor ? Int.random(in: 0..<5) : selectedColor
                            sessionItemViewModel.createItem(color: newColor)
                            sessionViewModel.updateDateModified()
                            
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
                            // Suggestion carousel
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
                                    }
                                    
                                    // Idea Text
                                    Menu(sessionItemViewModel.generatedIdeas[ideasIndex]) {
                                        // Copy Text
                                        Button {
                                            UIPasteboard.general.string =
                                                sessionItemViewModel.generatedIdeas[ideasIndex]
                                        } label: {
                                            Label("Copy", systemImage: "doc.on.doc")
                                        }
                                        // Close Ideas
                                        Button {
                                            sessionItemViewModel.clearIdeas()
                                        } label: {
                                            Label("Close", systemImage: "xmark")
                                        }
                                    }
                                    .font(.title2)
                                    
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
                                    }
                                }
                                .frame(minWidth: 20)
                                .padding(10)
                                .background(Color("BackgroundColor"))
                                .clipped()
                                .cornerRadius(15)
                                .shadow(radius: 4, y: 4)
                            }
                            
                            // AI Word Generation button
                            Button {
                                sessionItemViewModel.clearIdeas()
                                ideasIndex = 0
                                sessionItemViewModel.generateIdeas()
                            } label: {
                                Image("brainwriting")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 90, height: 90)
                                    .padding(.top, 8)
                                    .shadow(radius: 4, y: 4)
                            }
                            .padding(.trailing)
                        }
                        .padding(.top)
                        
                        HStack {
                            if timerManager.timeRemaining == 0 {
                                Text("Time to vote!")
                                    .font(.title2)
                                    .frame(minWidth: 20)
                                    .padding(10)
                                    .background(Color("BackgroundColor"))
                                    .clipped()
                                    .cornerRadius(15)
                                    .shadow(radius: 4, y: 4)
                            }
                            
                            // Voting Button
                            Button {
                                showSheet = .voting
                            } label: {
                                if timerManager.timeRemaining == 0 {
                                    Image("voting")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 70, height: 70)
                                        .padding(.trailing, 8)
                                        .shadow(radius: 4)
                                        .offset(y: isBouncing ? -8 : -2)
                                        .animation(isBouncing ? .interpolatingSpring(mass: 8, stiffness: 150, damping: 0).repeatForever(autoreverses: false) : nil)
                                } else {
                                    Image("voting")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 70, height: 70)
                                        .padding(.trailing, 8)
                                        .shadow(radius: 4)
                                        .animation(.easeInOut)
                                }
                            }
                            .padding(.trailing)
                        }
                        .padding(.top, 25)

                        // Settings gear button for Session Preferences
                        if groupViewModel.isCurrentUserAdmin(groupId: groupViewModel.selectedGroup?.groupId ?? "no ID") {
                            Button {
//                                showSheet = .settings
                                
                                sessionViewModel.getProfanityList(sessionMembers: groupViewModel.selectedGroup?.members ?? ["N/a"])
                            } label: {
                                Image("settings")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 70, height: 70)
                                    .padding(.trailing, 8)
                                    .shadow(radius: 4)
                            }
                            .padding(.trailing)
                            .padding(.top, 25)
                        }
                        Spacer()
                    }
                }
            }
            .sheet(item: $showSheet) { item in
                switch item {
                case .voting:
                    VotingSheet(showSheet: $showSheet, selectedSession: $sessionViewModel.selectedSession)
                        .environmentObject(self.sessionItemViewModel)
                case .settings:
                    SessionSettingsSheet(showSheet: $showSheet, settings: $sessionSettingsViewModel.settings[1], textTime: $sessionSettingsViewModel.textTime, textScore: $sessionSettingsViewModel.textScore)
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
            if timerManager.timeRemaining == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isBouncing = true
                }
            }
        }
        .onChange(of: timerManager.mode, perform: { mode in
            if mode == .finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isBouncing = true
                }
                sessionViewModel.toggleTimer(timeRemaining: Double(timerManager.timeRemaining))
            } else {
                isBouncing = false
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
