//
//  SubGroupsList.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-26.
//

import SwiftUI

struct SubGroupsList: View {
    var body: some View {
        
        VStack {
            List{
                SubGroup(title: "Marketing", selected: true)
                
                SubGroup(title: "Finance")
                
                SubGroup(title: "Sales")
                
                SubGroup(title: "Other")
                
                SubGroup(title: "Research and Development")
            }
            .edgesIgnoringSafeArea(.all)
            
            Spacer()
        }
    }
}

struct SubGroupsList_Previews: PreviewProvider {
    static var previews: some View {
        SubGroupsList()
    }
}
