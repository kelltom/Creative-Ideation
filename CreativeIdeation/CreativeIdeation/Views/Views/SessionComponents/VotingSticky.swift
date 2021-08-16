//
//  VotingSticky.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-08-16.
//

import SwiftUI

struct VotingSticky: View, Identifiable {
    var id = UUID()
    
    @State var itemId: String = ""
    @State var chosenColor = Color.red
    @State var input = "Hello"
    @State private var translation: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .foregroundColor(chosenColor)
                    .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.05)

                Text(input)
                    .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.25)
                    .background(chosenColor.opacity(0.5))
                    .foregroundColor(Color("StrokeColor"))
            }
            .cornerRadius(10)
            .animation(.interactiveSpring())
            .offset(x: self.translation.width, y: 0)
            .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.translation = value.translation
                    }.onEnded { value in
                        self.translation = .zero
                    }
            )
        }
    }
}

struct VotingSticky_Previews: PreviewProvider {
    static var previews: some View {
        VotingSticky()
    }
}
