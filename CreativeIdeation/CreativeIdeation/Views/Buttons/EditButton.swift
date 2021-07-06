//
//  EditButton.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct EditBtn: View {
    var body: some View {
        Image(systemName: "square.and.pencil")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 55, height: 55)
            .foregroundColor(Color.gray)
    }
}

struct EditButton_Previews: PreviewProvider {
    static var previews: some View {
        EditBtn()
    }
}
