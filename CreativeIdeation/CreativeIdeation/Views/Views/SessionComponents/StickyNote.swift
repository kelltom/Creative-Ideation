//
//  StickyNote.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-04-07.
//

import SwiftUI

struct StickyNote: View, Identifiable {
    var id = UUID()
    @EnvironmentObject var sessionItemViewModel: SessionItemViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var sessionSettingsViewModel: SessionSettingsViewModel
    @Environment(\.colorScheme) var colorScheme

    @State var input: String

    var itemId: String
    @State var textChanged: Bool = false
    @State var numberColor: Int = 1
    @State var chosenColor: Color? = Color.red
    @State var selected: Bool = false
    @State var score: Int = 0

    // @GestureState private var startLocation: CGPoint?
    @GestureState var isDetectingLongPress = false

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            VStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(colorScheme == .dark ? chosenColor?.darker() : chosenColor)
                    .frame(width: 160, height: 30)
                    .simultaneousGesture(barTap)
                    .popover(isPresented: $selected) {
                        HStack {
                            Button {
                                sessionItemViewModel.colorSelected(color: 0, filterProfanity: sessionSettingsViewModel.settings[1].filterProfanity)
                                sessionViewModel.updateDateModified()
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(sessionItemViewModel.colorArray[0])
                                        .frame(width: 25, height: 25)
                                    if chosenColor == sessionItemViewModel.colorArray[0] {
                                        Circle()
                                            .stroke(Color("BackgroundColor"), lineWidth: 2)
                                            .frame(width: 19, height: 19)
                                    }
                                }
                            }

                            Button {
                                sessionItemViewModel.colorSelected(color: 1, filterProfanity: sessionSettingsViewModel.settings[1].filterProfanity)
                                sessionViewModel.updateDateModified()
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(sessionItemViewModel.colorArray[1])
                                        .frame(width: 25, height: 25)
                                    if chosenColor == sessionItemViewModel.colorArray[1] {
                                        Circle()
                                            .stroke(Color("BackgroundColor"), lineWidth: 2)
                                            .frame(width: 19, height: 19)
                                    }
                                }
                            }

                            Button {
                                sessionItemViewModel.colorSelected(color: 2, filterProfanity: sessionSettingsViewModel.settings[1].filterProfanity)
                                sessionViewModel.updateDateModified()
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(sessionItemViewModel.colorArray[2])
                                        .frame(width: 25, height: 25)
                                    if chosenColor == sessionItemViewModel.colorArray[2] {
                                        Circle()
                                            .stroke(Color("BackgroundColor"), lineWidth: 2)
                                            .frame(width: 19, height: 19)
                                    }
                                }
                            }

                            Button {
                                sessionItemViewModel.colorSelected(color: 3, filterProfanity: sessionSettingsViewModel.settings[1].filterProfanity)
                                sessionViewModel.updateDateModified()
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(sessionItemViewModel.colorArray[3])
                                        .frame(width: 25, height: 25)
                                    if chosenColor == sessionItemViewModel.colorArray[3] {
                                        Circle()
                                            .stroke(Color("BackgroundColor"), lineWidth: 2)
                                            .frame(width: 19, height: 19)
                                    }
                                }
                            }

                            Button {
                                sessionItemViewModel.colorSelected(color: 4, filterProfanity: sessionSettingsViewModel.settings[1].filterProfanity)
                                sessionViewModel.updateDateModified()
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(sessionItemViewModel.colorArray[4])
                                        .frame(width: 25, height: 25)
                                    if chosenColor == sessionItemViewModel.colorArray[4] {
                                        Circle()
                                            .stroke(Color("BackgroundColor"), lineWidth: 2)
                                            .frame(width: 19, height: 19)
                                    }
                                }
                            }

                            if sessionItemViewModel.isUsersSticky() {
                                    Button {
                                        sessionItemViewModel.deleteSelected()
                                    } label: {
                                        Image(systemName: "trash.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(Color("StrokeColor"))
                                    }
                            }
                        }
                        .padding()
                    }

                TextEditor(text: $input)
                    .frame(width: 160, height: 130)
                    .background(colorScheme == .dark ? chosenColor?.darker(by: 15.0) : chosenColor?.lighter(by: 20.0))
                    .foregroundColor(Color("StrokeColor"))

                    .onChange(of: input, perform: {_ in
                        textChanged = true
                    })
            }
            .cornerRadius(10)

            if textChanged {
                Button {
                    // Save text to DB
                    if sessionSettingsViewModel.settings[1].filterProfanity {
                        sessionViewModel.checkProfanity(textInput: input)
                    }
                    sessionItemViewModel.updateText(text: input, itemId: itemId, filterProfanity: sessionSettingsViewModel.settings[1].filterProfanity)
                    sessionItemViewModel.updateItem(itemId: itemId)
                    sessionViewModel.updateDateModified()
                    textChanged = false

                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(chosenColor)
                        .padding(5)
                }
            }
        }
        .clipped()
        .shadow(color: selected ? Color.black : Color.clear, radius: 4, y: 4 )
        .onChange(of: selected) { _ in
            if selected {
                sessionItemViewModel.updateSelected(note: self)
            } else {
                sessionItemViewModel.updateItem(itemId: itemId)
                sessionItemViewModel.clearSelected()
            }
        }
        .onAppear {
            if selected {
                sessionItemViewModel.updateSelected(note: self)
            }
        }
        .onAppear(perform: {
            UITextView.appearance().backgroundColor = .clear
        })
    }

    func getSelected() -> Bool {
        return selected
    }

    var barTap: some Gesture {
        TapGesture()
            .onEnded {_ in
                self.selected = true
            }
    }
}

struct StickyNote_Previews: PreviewProvider {
    static var previews: some View {
        StickyNote(input: "", itemId: "")
            .environmentObject(SessionItemViewModel())
    }
}
