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

    @State var input: String
    @State var location: CGPoint

    var itemId: String
    @State var timer: Timer?
    @State var chosenColor: Color? = Color.red
    @State var selected: Bool = false

    @GestureState private var startLocation: CGPoint?
    @GestureState var isDetectingLongPress = false

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundColor(chosenColor)
                .frame(width: 160, height: 30)
                .simultaneousGesture(longPress)
                .simultaneousGesture(simpleDrag)

            TextEditor(text: $input)
                .frame(width: 160, height: 130)
                .opacity(0.7)
                .background(chosenColor)
                .foregroundColor(.black)
                .onChange(of: input, perform: {_ in
                    timer?.invalidate()
                    timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                        sessionItemViewModel.updateText(text: input, itemId: itemId)
                        sessionItemViewModel.updateItem(itemId: itemId)
                    }
                })
        }
        .cornerRadius(10)
        .shadow(color: selected ? Color.black : Color.clear, radius: 6, y: 4 )
        .position(location)
        .onAppear {
            if selected {
                sessionItemViewModel.updateSelected(note: self)
            }
        }
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

    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                if newLocation.y < 80 {
                    newLocation.y = 80
                }
                self.location = newLocation}
            .onEnded {_ in
                sessionItemViewModel.updateLocation(location: location, itemId: itemId)
                sessionItemViewModel.updateItem(itemId: itemId)
            }
    }
}

struct StickyNote_Previews: PreviewProvider {
    static var previews: some View {
        StickyNote(input: "", location: CGPoint(x: 300, y: 300), itemId: "")
            .environmentObject(SessionItemViewModel())
    }
}
