//
//  SessionItem.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct SessionTile: View {

    @EnvironmentObject var teamViewModel: TeamViewModel

    var title: String = "Example Title"
    var activity: String = "Sticky Notes"
    var image: String = "post-it"
    @State var owner: Member = Member()
    @State var ownerIndex: Int = -2
    var date: Date
    var inProgress: Bool = true
    var team: String = "Big Company"
    var group: String = "Marketing"
    let formatter = DateFormatter()

    var session: Session

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
                    .foregroundColor(Color("FadedColor"))

                Spacer()

                if #available(iOS 15.0, *) {
                    if Calendar.current.isDateInToday(date) {
                        Text(date.formatted(.dateTime .hour() .minute())) // formatter.string(from: date)
                            .font(.caption)
                            .foregroundColor(Color("FadedColor"))
                    } else {
                        Text(date.formatted(.dateTime .month(.wide) .day() .year())) // formatter.string(from: date)
                            .font(.caption)
                            .foregroundColor(Color("FadedColor"))
                    }
                } else {
                    Text(formatter.string(from: date)) // formatter.string(from: date)
                        .font(.caption)
                        .foregroundColor(Color("FadedColor"))
                }
            }
            .padding(3)

            Text(session.sessionTitle)
                .font(.title3)
                .foregroundColor(Color("StrokeColor"))

            Text(team + " - " + group)
                .font(.caption)
                .italic()
                .foregroundColor(Color("StrokeColor"))

            HStack(alignment: .bottom, spacing: 5) {
                if teamViewModel.memberPics[session.createdBy] != nil {
                    teamViewModel.memberPics[session.createdBy]!
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    ProfilePic(size: 40, initial: owner.name.prefix(1))
                }

                Text(owner.name)
                    .font(.caption)
                    .foregroundColor(Color("FadedColor"))

                Spacer()
            }
            .padding(.bottom, 5)
            .padding(.horizontal, 10)
        }
        .frame(width: 200, height: 200)
        .cornerRadius(25)
        .overlay(RoundedRectangle(cornerRadius: 25.0)
                    .stroke(Color("StrokeColor"), lineWidth: 2.0))
        .onAppear {
            formatter.dateStyle = .medium
            ownerIndex = teamViewModel.getOwner(id: session.createdBy)
        }
        .onChange(of: ownerIndex, perform: { _ in
            if ownerIndex < 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    ownerIndex = teamViewModel.getOwner(id: session.createdBy)

                }
            } else {
                owner = teamViewModel.teamMembers[ownerIndex]
            }
        })
    }
}

struct SessionItem_Previews: PreviewProvider {
    static var previews: some View {
        SessionTile(owner: Member(), date: Date(), session: Session(sessionTitle: "Sample Title", type: "Sticky Notes"))
    }
}
