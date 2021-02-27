//
//  RecentSessionList.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct RecentSessionList: View {
    var body: some View {
        List{
            RecentSession(title: "New Product")
            
            RecentSession(title: "Marketing Campaign")
            
            RecentSession(title: "Brand Name and Logo")
        }
        .frame(minHeight: 270)
    }
}

struct RecentSessionList_Previews: PreviewProvider {
    static var previews: some View {
        RecentSessionList()
    }
}
