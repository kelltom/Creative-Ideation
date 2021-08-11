//
//  CodeGeneratorView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-19.
//

import SwiftUI

struct TeamAccessCode: View {

    @Binding var showSheets: ActiveSheet?
    @State var isCopied: Bool = false
    @EnvironmentObject var teamViewModel: TeamViewModel

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            VStack {
                XDismissButton(isShowingSheet: $showSheets)
                Spacer()
            }

            VStack {
                Text("Team Access Code")
                    .font(.largeTitle)
                    .foregroundColor(Color("StrokeColor"))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding()

                VStack {
                    HStack {
                        Spacer()
                        Text(teamViewModel.selectedTeam?.accessCode ?? "Select a team")
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer()
                        Button {
                            // needs to copy to users keyboard
                            UIPasteboard.general.string = teamViewModel.selectedTeam?.accessCode
                                isCopied = true
                        }label: {
                            Image(systemName: "doc.on.doc")

                        }

                    }

                }
                .padding()
                .frame(width: 400, height: 80, alignment: .center)
                .border(Color.white, width: 1.0)
                .background(Color("BackgroundColor"))

                ZStack {
                    if isCopied {
                        Text("Copied to clipboard!").foregroundColor(.white)
                    }
                }
            }
            .frame(maxWidth: 600, maxHeight: 400, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(Color("brandPrimary"), lineWidth: 2.5)
            )
            .background(Color("brandPrimary"))
            .cornerRadius(25.0)
        }

    }

//    private func delayAlert() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            withAnimation {
//                isCopied = false
//            }
//        }
//    }

}

struct CodeGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        TeamAccessCode(showSheets: .constant(.addTeamMembers))
    }
}
