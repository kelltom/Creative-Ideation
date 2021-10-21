//
//  CreateStickyView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-10-21.
//

import SwiftUI

struct CreateStickyView: View {

    @EnvironmentObject var sessionViewModel: SessionViewModel
    @EnvironmentObject var sessionItemViewModel: SessionItemViewModel
    @Environment(\.colorScheme) var colorScheme

    let colorArray = [Color.init(red: 0.9, green: 0, blue: 0),
                      Color.init(red: 0.9, green: 0.6, blue: 0),
                      Color.init(red: 0, green: 0.9, blue: 0),
                      Color.init(red: 0, green: 0.7, blue: 0.9),
                      Color.init(red: 0.9, green: 0.45, blue: 0.9)]

    @Binding var newStickyPopover: Bool
    @State var chosenColor: Int

    @State var input = ""

    var body: some View {
        VStack {
            HStack {
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(colorScheme == .dark ? colorArray[chosenColor].darker() : colorArray[chosenColor])
                        .frame(width: 160, height: 30)

                    TextEditor(text: $input)
                        .frame(width: 160, height: 130)
                        .background(colorScheme == .dark ? colorArray[chosenColor].darker(by: 15.0) : colorArray[chosenColor].lighter(by: 20.0))
                        .foregroundColor(Color("StrokeColor"))
                }
                .cornerRadius(10)

                VStack {
                    Button {
                        chosenColor = 0
                    } label: {
                        ZStack {
                            Circle()
                                .fill(colorArray[0])
                                .frame(width: 25, height: 25)
                            if chosenColor == 0 {
                                Circle()
                                    .stroke(Color("BackgroundColor"), lineWidth: 2)
                                    .frame(width: 19, height: 19)
                            }
                        }
                    }

                    Button {
                        chosenColor = 1
                    } label: {
                        ZStack {
                            Circle()
                                .fill(colorArray[1])
                                .frame(width: 25, height: 25)
                            if chosenColor == 1 {
                                Circle()
                                    .stroke(Color("BackgroundColor"), lineWidth: 2)
                                    .frame(width: 19, height: 19)
                            }
                        }
                    }

                    Button {
                        chosenColor = 2
                    } label: {
                        ZStack {
                            Circle()
                                .fill(colorArray[2])
                                .frame(width: 25, height: 25)
                            if chosenColor == 2 {
                                Circle()
                                    .stroke(Color("BackgroundColor"), lineWidth: 2)
                                    .frame(width: 19, height: 19)
                            }
                        }
                    }

                    Button {
                        chosenColor = 3
                    } label: {
                        ZStack {
                            Circle()
                                .fill(colorArray[3])
                                .frame(width: 25, height: 25)
                            if chosenColor == 3 {
                                Circle()
                                    .stroke(Color("BackgroundColor"), lineWidth: 2)
                                    .frame(width: 19, height: 19)
                            }
                        }
                    }

                    Button {
                        chosenColor = 4
                    } label: {
                        ZStack {
                            Circle()
                                .fill(colorArray[4])
                                .frame(width: 25, height: 25)
                            if chosenColor == 4 {
                                Circle()
                                    .stroke(Color("BackgroundColor"), lineWidth: 2)
                                    .frame(width: 19, height: 19)
                            }
                        }
                    }
                }
            }

            Button {
                sessionViewModel.sessionBehaviourSummary(textInput: input)
                sessionItemViewModel.createItem(color: chosenColor, input: input)
                sessionViewModel.updateDateModified()
                input = ""
                chosenColor = Int.random(in: 0..<5)
            } label: {
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15, height: 15)
                    .foregroundColor(.white)
                    .frame(width: 192, height: 30)
                    .background(Color.green)
                    .cornerRadius(5)
                    .padding(.top, 5)
            }
        }
        .padding()
        .onAppear(perform: {
            UITextView.appearance().backgroundColor = .clear
        })
    }
}

struct CreateStickyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateStickyView(newStickyPopover: .constant(true), chosenColor: 0)
    }
}
