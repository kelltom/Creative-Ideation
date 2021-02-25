//
//  SearchBarView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
     
    @State private var isEditing = false
    
    var body: some View {
        HStack{
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing{
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                }) {
                   Text("Cancel")
                }
                .padding(.trailing)
                .transition(.move(edge: .trailing))
                .animation(.default)
            
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(text: .constant(""))
    }
}
