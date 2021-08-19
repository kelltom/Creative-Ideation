//
//  MenuTextField.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-02-19.
//

import SwiftUI

struct EditTextField: View {

    var title: String
    @Binding var input: String
    var secure: Bool = false
    var geometry: GeometryProxy
    var widthScale: CGFloat = 0.6

    var body: some View {
        if secure {
            SecureField(title, text: $input )
                .padding()
                .frame(width: geometry.size.width * widthScale, height: 60, alignment: .center/*@END_MENU_TOKEN@*/)
                .overlay(RoundedRectangle(cornerRadius: 8.0)
                            .stroke(Color("StrokeColor")))
                .font(.title2)
                .padding(10)
        } else {
            TextField(title, text: $input )
                .padding()
                .frame(width: geometry.size.width * widthScale, height: 60, alignment: .center/*@END_MENU_TOKEN@*/)
                .overlay(RoundedRectangle(cornerRadius: 8.0)
                            .stroke(Color("StrokeColor")))
                .font(.title2)
                .padding(10)
        }

    }
}
