//
//  SessionsList.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct SessionsList: View {
    var body: some View {
        List{
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
        .overlay(Rectangle().stroke(Color.gray))
    }
}

struct SessionsList_Previews: PreviewProvider {
    static var previews: some View {
        SessionsList()
    }
}
