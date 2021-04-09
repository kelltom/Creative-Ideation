//
//  UpdateNameView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-04-09.
//

import SwiftUI

struct UpdateNameView: View {
    @State var newName: String = ""
    @State var currentName: String = ""
    @Binding var showSheet: PreferenceSheet?

    @EnvironmentObject var userAccountViewModel: UserAccountViewModel

    var body: some View {
        ZStack {
            if userAccountViewModel.showBanner {
                if !userAccountViewModel.createSuccess {
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

            VStack {
                Spacer()
                // main title
                Text("Change Display Name")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                VStack(alignment: .leading) {
                    Text("Current Display Name")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading)
                        .padding(.top)

                    Text(userAccountViewModel.selectedUser?.name ?? "NA").foregroundColor(.blue)
                        .padding()
                        .frame(width: 550, height: 60, alignment: .leading)
                        .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color.black))
                        .font(.title2)
                        .padding(10)

                    Text("New Display Name")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading)

                    MenuTextField(title: "new name ", input: $newName)

                }
                Button {
                    // save to DB call view model function to update DB
                    //userAccountViewModel.updateUserEmail(email: newName)
                    newName = ""
                } label: {
                    SubmitButton()
                }
                Spacer()
            }

        }

    }
}

struct UpdateNameView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateNameView(showSheet: .constant(.name))
            .environmentObject(UserAccountViewModel())
    }
}
