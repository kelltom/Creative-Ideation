//
//  SessionsList.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct SessionsList: View {
    
    let columns = [
        GridItem(.adaptive(minimum: 200))
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false){
            LazyVGrid(columns: columns, spacing: 40){
                NewSessionButton()
                SessionItem()
                SessionItem()
                SessionItem(title: "Stupidly long and unnecessary title")
                SessionItem()
                SessionItem()
                SessionItem()
                SessionItem()
                SessionItem()
                SessionItem()
            }
            .padding()
        }
        .padding(.top)
    }
}

struct SessionsList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SessionsList()
        }
    }
}

struct NewSessionButton: View {
    
    var body: some View {
        Image(systemName: "plus")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            .frame(width: 200, height: 200)
            .overlay(RoundedRectangle(cornerRadius: 25.0)
                        .stroke(Color.black, lineWidth: 2.0))
        
    }
}
