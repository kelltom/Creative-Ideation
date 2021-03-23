//
//  SearchBarView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    @State private var isSearching = false

    var body: some View {
        HStack {
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isSearching = true
                }

            if isSearching {
                Button(action: {
                    isSearching = false
                    text = ""
                }, label: {
                    Text("cancel")
                        .padding(.trailing)
                        .transition(.move(edge: .trailing))
                        .animation(.spring())
                })

            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(text: .constant(""))
    }
}
