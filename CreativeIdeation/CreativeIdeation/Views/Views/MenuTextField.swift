//
//  MenuTextField.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-02-19.
//

import SwiftUI

struct MenuTextField: View {
    
    var title: String
    @Binding var input: String
    
    var body: some View {
        TextField(title, text: $input )
            .padding()
            .frame(width: 550, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .overlay(RoundedRectangle(cornerRadius: 8.0)
                        .stroke(Color.black))
            .font(.system(size: 20))
            .padding(10)
    }
}

struct MenuTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        MenuTextField(title: "Test title", input: .constant("test"))
    }
}
