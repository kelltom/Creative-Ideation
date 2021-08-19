//
//  UpdateNameView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-04-09.
//

import SwiftUI

struct UpdateNameSheet: View {
    @State var newName: String = ""
    @State var currentName: String = ""
    @Binding var showSheet: PreferenceSheet?

    @EnvironmentObject var userAccountViewModel: UserAccountViewModel

    var body: some View {
        ZStack {

            Color("BackgroundColor")

            if userAccountViewModel.isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("brandPrimary")))
                    .scaleEffect(3)
            }

            if userAccountViewModel.showBanner {
                if !userAccountViewModel.updateSuccess {
                    NotificationBanner(image: "exclamationmark.circle.fill",
                                       msg: userAccountViewModel.msg, color: .red)
                } else {
                    NotificationBanner(image: "checkmark.circle.fill",
                                       msg: userAccountViewModel.msg, color: .green)
                }
            }
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showSheet = nil
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(.label))
                            .imageScale(.large)
                            .frame(width: 80, height: 80)
                    }
                }
                .padding()
                Spacer()
            }

            GeometryReader { geometry in
                VStack {
                    Spacer()
                    // main title
                    Text("Change Display Name")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    // Display Name
                    VStack(alignment: .leading) {
                        Text("Current Display Name")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.leading)
                            .padding(.top)
                        // Display name text view
                        Text(userAccountViewModel.selectedUser?.name ?? "N/A").foregroundColor(.blue)
                            .padding()
                            .frame(width: geometry.size.width * 0.75, height: 60, alignment: .leading)
                            .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color("StrokeColor")))
                            .font(.title2)
                            .padding(10)

                        // New disply name Entry
                        Text("New Display Name")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.leading)

                        EditTextField(title: "new name ", input: $newName, geometry: geometry, widthScale: 0.75)

                    }
                    Button {
                        // save to DB -- we can a profanity check here to make sure that they cant
                        // have a bad name
                        userAccountViewModel.updateUserName(name: newName)
                        newName = ""
                    } label: {
                        SubmitButton()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

        }

    }
}

struct UpdateNameView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateNameSheet(showSheet: .constant(.name))
            .preferredColorScheme(.dark)
            .environmentObject(UserAccountViewModel())
    }
}
