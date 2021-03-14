//
//  ActivityToolbar.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct ActivityToolbar: View {
    
    var body: some View {
        
        VStack{
            ToolButton(symbol_name: "arrow.up.and.down.and.arrow.left.and.right")
            ToolButton(selected: true, symbol_name: "pencil")
            ToolButton(symbol_name: "plus.square")
            ToolButton(symbol_name: "trash")
            ToolButton(symbol_name: "bubble.right")
            ToolButton(symbol_name: "questionmark.circle")
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
