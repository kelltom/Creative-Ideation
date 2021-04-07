//
//  StickyNote.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-04-07.
//

import SwiftUI

struct StickyNote: View {

    @EnvironmentObject var sessionItemViewModel: SessionItemViewModel

    @State var input: String
    @State var location: CGPoint

    var chosenColor: Color? = Color.red
    @State var selected: Bool = false

    @GestureState private var startLocation: CGPoint?
    @GestureState var isDetectingLongPress = false

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundColor(chosenColor)
                .frame(width: 125, height: 25)
                .simultaneousGesture(longPress)

            TextEditor(text: $input)
                .frame(width: 125, height: 100)
                .opacity(0.7)
                .background(chosenColor)
                .foregroundColor(.black)

        }
        .gesture(simpleDrag)
        .cornerRadius(10)
        .shadow(color: selected ? Color.black : Color.clear, radius: 6, y: 4 )
        .position(location)
    }

    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .onEnded {_ in
                self.selected.toggle()
                sessionItemViewModel.selectedSticky = self
            }
    }

    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                self.location = newLocation}
    }
}

struct StickyNote_Previews: PreviewProvider {
    static var previews: some View {
        StickyNote(input: "", location: CGPoint(x: 300, y: 300))
            .environmentObject(SessionItemViewModel())
    }
}
