//
//  UpdateNameView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-04-09.
//

import SwiftUI
import Profanity_Filter

struct UpdateNameSheet: View {
    @State var newName: String = ""
    @State var currentName: String = ""
    @State private var widthScale: CGFloat = 0.75
    @Binding var showSheet: PreferenceSheet?

    @EnvironmentObject var userAccountViewModel: UserAccountViewModel

    var pFilter = ProfanityFilter()

    var body: some View {
        ZStack {

            Color("BackgroundColor")

            if userAccountViewModel.isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("brandPrimary")))
                    .scaleEffect(3)
            }

            // Exit button
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

            // Main page content
            GeometryReader { geometry in

                VStack {

                    Spacer()

                    // main title
                    Text("Change Display Name")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                    // Display Name
                    VStack(alignment: .center) {
                        Text("Current Display Name")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.top)
                            .padding(.bottom, 10)
                            .frame(width: geometry.size.width * widthScale, alignment: .leading)

                        
                        // Display name text view
                        Text(userAccountViewModel.selectedUser?.name ?? "N/A").foregroundColor(.blue)
                            .padding()
                            .frame(width: geometry.size.width * 0.75, height: 60, alignment: .leading)
                            .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color("StrokeColor")))
                            .font(.title2)
                            .padding(.bottom,10)

                        // New disply name Entry
                        Text("New Display Name")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .frame(width: geometry.size.width * widthScale, alignment: .leading)

                        EditTextField(title: "Enter New Name ", input: $newName, geometry: geometry, widthScale: widthScale)
                    }

                    Button {
                        userAccountViewModel.updateUserName(name: newName)
                        newName = ""
                    } label: {
                        BigButton(title: "Submit", geometry: geometry, widthScale: 0.75)
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
    }
}

struct UpdateNameView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateNameSheet(showSheet: .constant(.name))
            .preferredColorScheme(.dark)
            .environmentObject(UserAccountViewModel())
    }
}
