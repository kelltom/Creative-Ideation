//
//  star.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-10-15.
//

import SwiftUI

struct Star: View {

    @Environment(\.colorScheme) var colorScheme

    @State var size: CGFloat = 50
    @State var color = Color.green
    @State var spin = false
    @State var inverted = false

    @State var timer: Timer?

    var body: some View {
        ZStack {
            Image(systemName: "rays")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size * 1.4, height: size * 1.4)
                .foregroundColor(color.lighter())
                .rotationEffect(inverted ? Angle.degrees(spin ? 0 : 30) : Angle.degrees(spin ? -10 : -40))
                .animation(.easeInOut(duration: 0.8))

            Image(systemName: "star.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .foregroundColor(color)
                .rotationEffect(inverted ? Angle.degrees(spin ? -10 : -40) : Angle.degrees(spin ? 0 : 30))
                .animation(.easeInOut(duration: 0.8))
        }
        .padding(20)
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true) { _ in
                spin.toggle()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}

struct Star_Previews: PreviewProvider {
    static var previews: some View {
        Star()
    }
}
