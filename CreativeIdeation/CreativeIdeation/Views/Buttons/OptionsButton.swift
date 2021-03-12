//
//  OptionsButton.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-03-11.
//

import SwiftUI

struct OptionsButton: View {
    var body: some View {
        Image(systemName: "ellipsis")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .padding(5)
            .overlay(Circle().stroke())
    }
}

struct OptionsButton_Previews: PreviewProvider {
    static var previews: some View {
        OptionsButton()
    }
}
