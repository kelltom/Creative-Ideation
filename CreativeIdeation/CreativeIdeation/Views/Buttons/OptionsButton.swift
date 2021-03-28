//
//  OptionsButton.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-03-11.
//

import SwiftUI

struct OptionsButton: View {
    var body: some View {
        Image(systemName: "ellipsis.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16)
            .foregroundColor(.black)
    }
}

struct OptionsButton_Previews: PreviewProvider {
    static var previews: some View {
        OptionsButton()
    }
}
