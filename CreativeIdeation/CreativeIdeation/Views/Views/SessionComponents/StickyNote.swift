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

    @State var input: String
    @State var location: CGPoint

    var itemId: String
    @State var textChanged: Bool = false
    @State var timer: Timer?
    @State var chosenColor: Color? = Color.red
    @State var selected: Bool = false

    // @GestureState private var startLocation: CGPoint?
    @GestureState var isDetectingLongPress = false

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            VStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(chosenColor)
                    .frame(width: 160, height: 30)
                    .simultaneousGesture(longPress)
                    // .simultaneousGesture(simpleDrag)

                TextEditor(text: $input)
                    .frame(width: 160, height: 130)
                    .background(chosenColor.opacity(0.5))
                    .foregroundColor(Color("StrokeColor"))
                    .onChange(of: input, perform: {_ in
                        textChanged = true
                    })
            }
            .cornerRadius(10)

            if textChanged {
                Button {
                    // Save text to DB
                    sessionItemViewModel.updateText(text: input, itemId: itemId)
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
        .shadow(color: selected ? Color.black : Color.clear, radius: 6, y: 4 )
        // .position(location)
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

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .onEnded {_ in
                self.selected = true
                sessionItemViewModel.updateSelected(note: self)
            }
    }

//    var simpleDrag: some Gesture {
//        DragGesture()
//            .onChanged { value in
//                var newLocation = startLocation ?? location
//                newLocation.x += value.translation.width
//                newLocation.y += value.translation.height
//                if newLocation.y < 80 {
//                    newLocation.y = 80
//                }
//                self.location = newLocation}
//            .onEnded {_ in
//                sessionItemViewModel.updateLocation(location: location, itemId: itemId)
//                if textChanged {
//                    sessionItemViewModel.updateText(text: input, itemId: itemId)
//                    textChanged = false
//                }
//                sessionItemViewModel.updateItem(itemId: itemId)
//                sessionViewModel.updateDateModified()
//            }
//    }
}

struct StickyNote_Previews: PreviewProvider {
    static var previews: some View {
        StickyNote(input: "", location: CGPoint(x: 300, y: 300), itemId: "")
            .environmentObject(SessionItemViewModel())
    }
}
