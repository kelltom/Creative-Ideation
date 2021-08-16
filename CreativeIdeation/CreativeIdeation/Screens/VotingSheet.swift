//
//  VotingSheet.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-08-16.
//

import SwiftUI

struct VotingSheet: View {

    @EnvironmentObject var sessionItemViewModel: SessionItemViewModel

    @Binding var showSheet: SessionSheet?
    @State private var stickies: [VotingSticky] = []

    var body: some View {
        VStack(alignment: .center) {

            Spacer()
            GeometryReader { geometry in

                ZStack{
                    ForEach(self.stickies) { sticky in
                        sticky
                    }
                }
            }
            Spacer()
            // space for buttons
        }
        .onAppear {
            stickies = sessionItemViewModel.populateVotingSheet()
        }
    }

}

struct VotingSheet_Previews: PreviewProvider {
    static var previews: some View {
        VotingSheet(showSheet: .constant(.voting))
            .environmentObject(SessionItemViewModel())
    }
}
