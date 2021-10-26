//
//  TutorialOverlay.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-10-26.
//

import SwiftUI

struct TutorialOverlay: View {

    @State var isPointing: Bool = false

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                // Create Teams Hint
                HStack(alignment: .top) {
                    Image(systemName: "arrow.up.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
//                        .offset(x: isPointing ? -7 : 7, y: isPointing ? -7 : 7)
                        .padding(.bottom)
                    Text("Tap the + to create or join a Team!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color("BackgroundColor"))
                        .cornerRadius(15)
                        .clipped()
                        .shadow(radius: 5, y: 3)
                        .padding(.top, 50)
                }

                Spacer()
                Spacer()
                    .frame(width: 100)
                Spacer()

                // Edit User Settings Hint
                VStack(alignment: .trailing) {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
//                        .offset(y: isPointing ? -7 : 7)
//                        .animation(.interpolatingSpring(stiffness: 25, damping: 0).repeatForever(), value: isPointing)
                        .padding(.trailing, 15)
                    Text("Tap here to edit user settings!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color("BackgroundColor"))
                        .cornerRadius(15)
                        .clipped()
                        .shadow(radius: 5, y: 3)
                        .padding(.top)
                }
            }
            .padding()

            Spacer()

            HStack {
                Spacer()

                // Get Help Hint
                HStack(alignment: .bottom) {
                    Text("Need help? Tap here!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color("BackgroundColor"))
                        .cornerRadius(15)
                        .clipped()
                        .shadow(radius: 5, y: 3)
                        .padding(.bottom, 40)
                    Image(systemName: "arrow.down.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
//                        .offset(x: isPointing ? 7 : -7, y: isPointing ? 7 : -7)
//                        .animation(.interpolatingSpring(stiffness: 25, damping: 0).repeatForever())
                        .padding(.top, 50)
                }
                .padding(.trailing, 100)
                .padding(.bottom, 100)
            }

        }
        .foregroundColor(Color("StrokeColor"))
        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                isPointing = true
//            }
        }
    }
}

struct TutorialOverlay_Previews: PreviewProvider {
    static var previews: some View {
        TutorialOverlay()
    }
}
