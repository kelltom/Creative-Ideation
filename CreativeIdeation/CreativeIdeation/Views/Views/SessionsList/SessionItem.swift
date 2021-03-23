//
//  SessionItem.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct SessionItem: View {

    var title: String = "Example Title"
    var activity: String = "Sticky Notes"
    var image: String = "post-it"
    var date: String = "25-Feb-2021"
    var inProgress: Bool = true
    var team: String = "Big Company"
    var group: String = "Marketing"

    var body: some View {
        VStack(spacing: 3) {

            VStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.yellow]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing))

            HStack {
                Text(activity)
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                Text(date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(3)

            Text(title)
                .font(.title3)

            Text(team + " - " + group)
                .font(.caption)
                .italic()

            HStack(alignment: .bottom, spacing: 5) {
                ProfilePic(size: 30)

                Text("Owner")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                OptionsButton()
            }
            .padding(.bottom, 5)
            .padding(.horizontal, 10)
        }
        .frame(width: 200, height: 200)
        .cornerRadius(25)
        .overlay(RoundedRectangle(cornerRadius: 25.0)
                    .stroke(Color.black, lineWidth: 2.0))
    }
}

struct SessionItem_Previews: PreviewProvider {
    static var previews: some View {
        SessionItem()
    }
}
