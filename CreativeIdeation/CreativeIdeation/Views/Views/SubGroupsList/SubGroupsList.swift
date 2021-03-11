//
//  SubGroupsList.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-26.
//

import SwiftUI

struct SubGroupsList: View {
    var body: some View {
        List{
            SubGroup(title: "Marketing", selected: true)
            
            SubGroup(title: "Finance")
            
            SubGroup(title: "Other")
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SubGroupsList_Previews: PreviewProvider {
    static var previews: some View {
        SubGroupsList()
    }
}
