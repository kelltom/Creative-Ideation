//
//  BackButton.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-09-17.
//

import SwiftUI

/// Custom back button to replace NavigationView's back button
struct BackButton: View {

    @State var text: String /// Title of back button
    @Binding var binding: Bool /// Binding variable that will be toggled false upon clicking back button

    var body: some View {
        VStack {
            HStack {
                Button {
                    binding = false
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(" " + text)
                            .font(.title3)
                    }
                }
                Spacer()
            }
            .padding(.leading, 30)
            Spacer()
        }
        .padding(.top)
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton(text: "Back", binding: .constant(true))
    }
}
