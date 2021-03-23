//
//  ToolButton.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct ToolButton: View {

    var selected: Bool = false
    var symbolName: String = "pencil"

    var body: some View {
        Button {
            // Move button
        } label: {
        Image(systemName: symbolName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 65, height: 65)
            .foregroundColor(selected ? Color.black : Color.gray)
            .padding(15)
        }
    }
}

struct ToolButton_Previews: PreviewProvider {
    static var previews: some View {
        ToolButton()
    }
}
