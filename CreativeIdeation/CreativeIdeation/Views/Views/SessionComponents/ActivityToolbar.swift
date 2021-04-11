//
//  ActivityToolbar.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct ActivityToolbar: View {

    var body: some View {

        VStack {
            ToolButton(symbolName: "arrow.up.and.down.and.arrow.left.and.right")
            ToolButton(selected: true, symbolName: "pencil")
            ToolButton(symbolName: "plus.square")
            ToolButton(symbolName: "trash")
            ToolButton(symbolName: "bubble.right")
            ToolButton(symbolName: "questionmark.circle")
        }
        .frame(minHeight: 400)
        .background(Color.white)
        .cornerRadius(20)
        .clipped()
        .shadow(color: .black, radius: 4, y: 4)
    }
}

struct ActivityToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ActivityToolbar()
    }
}
