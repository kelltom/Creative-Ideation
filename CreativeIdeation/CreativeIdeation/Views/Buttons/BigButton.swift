//
//  BigButton.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-02-19.
//

import SwiftUI

struct BigButton: View {

    var title: String
    var geometry: GeometryProxy
    var widthScale: CGFloat = 0.6

    var body: some View {
        Text(title)
            .frame(width: geometry.size.width * widthScale, height: 60, alignment: .center)
            .background(Color("brandPrimary"))
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.title2)
            .padding()
            .shadow(radius: 5, x: 5, y: 5)
    }
}
