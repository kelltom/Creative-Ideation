//
//  XDismissButton.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-13.
//

import SwiftUI

struct XDismissButton: View {
    @Binding var isShowingSheet: Bool
    var body: some View {
        HStack{
            Spacer()
            Button{
                isShowingSheet = false
                
            } label:{
                Image(systemName: "xmark")
                    .foregroundColor(Color(.label))
                    .imageScale(.large)
                    .frame(width: 80, height: 80)
            }
        }
        .padding()
    }
}

struct XDismissButton_Previews: PreviewProvider {
    static var previews: some View {
        XDismissButton(isShowingSheet: .constant(true))
    }
}
