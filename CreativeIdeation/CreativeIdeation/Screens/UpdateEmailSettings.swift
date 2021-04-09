//
//  UpdateEmailSettings.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-04-07.
//

import SwiftUI

struct UpdateEmailSettings: View {
    @State var newEmail: String = ""
    @State var currentEmail: String = ""
    @Binding var showSheet: Bool

    @EnvironmentObject var userAccountViewModel: UserAccountViewModel

    var body: some View {
        ZStack {
            if userAccountViewModel.showBanner {
                if !userAccountViewModel.createSuccess {
                    NotificationBanner(image: "exclamationmark.circle.fill", msg: userAccountViewModel.msg, color: .red)
                } else {
                    NotificationBanner(image: "checkmark.circle.fill", msg: userAccountViewModel.msg, color: .green)
                }
            }
            VStack {
                HStack {
                    Spacer()
                    Button {
                        self.showSheet = false
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

            VStack {
                Spacer()

                Text("Change Email")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                VStack(alignment: .leading) {
                    Text("Current Email")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading)
                        .padding(.top)

                    Text(userAccountViewModel.selectedUser?.email ?? "NA").foregroundColor(.blue)
                        .padding()
                        .frame(width: 550, height: 60, alignment: .leading)
                        .overlay(RoundedRectangle(cornerRadius: 8.0)
                                    .stroke(Color.black))// .background(RoundedRectangle(cornerRadius: 8.0).fill(Color.gray))
                        .font(.title2)
                        .padding(10)

                    Text("New Email")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading)

                    MenuTextField(title: "new email ", input: $newEmail)

                }
                Button {
                    // save to DB call view model function to update DB
                    userAccountViewModel.updateUserInfo(email: newEmail)
                    newEmail = ""
                } label: {
                    SubmitButton()
                }
                Spacer()
            }

        }

    }
}

struct UpdateEmailSettings_Previews: PreviewProvider {
    static var previews: some View {
        UpdateEmailSettings(showSheet: .constant(false))
            .environmentObject(UserAccountViewModel())

    }
}
