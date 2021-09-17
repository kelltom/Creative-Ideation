//
//  UpdatePasswordSetttings.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-04-09.
//

import SwiftUI

struct UpdatePasswordSheet: View {

    @State var newPassword: String = ""
    @State var oldPassword: String = ""
    @State var confirmPassword: String = ""
    @State private var widthScale: CGFloat = 0.75

    @Binding var showSheet: PreferenceSheet?
    @EnvironmentObject var userAccountViewModel: UserAccountViewModel

    var body: some View {
        ZStack {

            Color("BackgroundColor")

            if userAccountViewModel.isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("brandPrimary")))
                    .scaleEffect(3)
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

                    // Sheet Title
                    Text("Change Password")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.bottom)
                        .padding(.top)

                    Text("A strong password helps prevent unauthorized access to your account")
                        .padding()

                    VStack(alignment: .center) {

                        // Enter New Password TextField
                        Text("Enter New Password")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .frame(width: geometry.size.width * widthScale, alignment: .leading)

                        EditTextField(title: "Enter New Password ", input: $newPassword, secure: true, geometry: geometry, widthScale: widthScale).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)

                        // Re-enter New Password Text box
                        Text("Re-enter New Password")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .frame(width: geometry.size.width * widthScale, alignment: .leading)

                        EditTextField(title: "Re-enter New Password ", input: $confirmPassword, secure: true, geometry: geometry, widthScale: widthScale).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)

                        // Confirm change Text Field
                        Text("Old Password")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .frame(width: geometry.size.width * widthScale, alignment: .leading)

                        EditTextField(title: "Enter Old Password to Confirm Change", input: $oldPassword, secure: true, geometry: geometry, widthScale: widthScale).autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)

                    }

                    Button {
                        // Update to DB
                        userAccountViewModel.updateUserPassword(newPassword: newPassword,
                                                                confirmPassword: confirmPassword,
                                                                oldPassword: oldPassword)
                        newPassword = ""
                        confirmPassword = ""
                        oldPassword = ""
                    } label: {
                        BigButton(title: "Submit", geometry: geometry, widthScale: widthScale)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .banner(data: $userAccountViewModel.bannerData,
                    show: $userAccountViewModel.showBanner)
        }
        .onAppear {
            userAccountViewModel.showBanner = false
        }
        .onDisappear {
            // if flag is true means update is sucessful and log user out
            if userAccountViewModel.logOutFlag {
                userAccountViewModel.logOutFlag = false
                userAccountViewModel.signOut()
            }
            showSheet = nil
        }
    }
}

struct UpdatePasswordSetttings_Previews: PreviewProvider {
    static var previews: some View {
        UpdatePasswordSheet(showSheet: .constant(.password)).preferredColorScheme(.dark).environmentObject(UserAccountViewModel())
    }
}
