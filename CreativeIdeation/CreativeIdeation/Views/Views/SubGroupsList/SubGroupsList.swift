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
            List {

                GroupButton(title: "Marketing", selected: true)

                GroupButton(title: "Finance")

                GroupButton(title: "Sales")

                GroupButton(title: "Other")

                GroupButton(title: "Research and Development")
            }
        }
    }
}

struct SubGroupsList_Previews: PreviewProvider {
    static var previews: some View {
        SubGroupsList()
    }
}
