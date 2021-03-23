//
//  InputErrorBanner.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-03-13.
//

import SwiftUI

struct NotificationBanner: View {
    var image: String
    var msg: String
    var color: Color

    var body: some View {
        VStack {
            HStack {
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.white)

                Text(msg)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: 80)
            .background(color)
            .cornerRadius(25)
            .padding()

            Spacer()
        }
    }
}

struct NotificationBanner_Previews: PreviewProvider {
    static var previews: some View {
        NotificationBanner(image: "checkmark", msg: "success", color: .green)
    }
}
