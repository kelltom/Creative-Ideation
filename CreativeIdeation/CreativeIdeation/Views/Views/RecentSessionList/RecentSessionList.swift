//
//  RecentSessionList.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct RecentSessionList: View {

    let columns = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 50) {
                SessionItem()

                SessionItem(group: "Sales")

                SessionItem(group: "Sales")

                SessionItem(group: "Finance")

                SessionItem()
            }
            .padding(.leading)
        }
        .frame(maxHeight: 225)
    }
}

struct RecentSessionList_Previews: PreviewProvider {
    static var previews: some View {
        RecentSessionList()
    }
}
