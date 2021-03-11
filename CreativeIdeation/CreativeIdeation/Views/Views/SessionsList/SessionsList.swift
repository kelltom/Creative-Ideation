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
        ScrollView{
            LazyVGrid(columns: columns, spacing: 40){
                SessionItem(title: "Stupidly long and unnecessary title")
                SessionItem()
                SessionItem(inProgress: false)
                SessionItem(inProgress: false)
                SessionItem(inProgress: false)
                SessionItem(inProgress: false)
                SessionItem(inProgress: false)
                SessionItem(inProgress: false)
                SessionItem(inProgress: false)
            }
        }
        .padding(.top)
    }
}

struct SessionsList_Previews: PreviewProvider {
    static var previews: some View {
        SessionsList()
    }
}
