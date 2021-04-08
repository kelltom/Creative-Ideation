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

    @EnvironmentObject var viewModel: UserAccountViewModel

    var body: some View {
        ZStack {
            if viewModel.showBanner {
                if !viewModel.createSuccess {
                    NotificationBanner(image: "exclamationmark.circle.fill", msg: viewModel.msg, color: .red)
                } else {
                    NotificationBanner(image: "checkmark.circle.fill", msg: viewModel.msg, color: .green)
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
                VStack {
                    Text("Change email")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .background(Rectangle()
                                .fill(Color("brandPrimary"))
                                .frame(width: 500, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/))
                Spacer()
                VStack(alignment: .leading) {
                    Text("Current Email")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading)
                        .padding(.top)
                    TextField(viewModel.selectedUser?.email ?? "unknown", text: $currentEmail)
                        .foregroundColor(.black)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .padding()
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                        .padding()
                    

                    Text("New Email")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading)
                    TextField("new email", text: $newEmail )
                        .padding()
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                        .padding()

                }
                Button {
                    // save to DB call view model function to update DB
                    viewModel.updateUserInfo(email: newEmail)
                    newEmail = ""
                } label: {
                    SubmitButton()
                }
                Spacer()
            }
            .frame(width: 500, height: 500, alignment: .center)
            .background(Color.white).border(Color.black)
        }

    }
}

struct UpdateEmailSettings_Previews: PreviewProvider {
    static var previews: some View {
        UpdateEmailSettings(showSheet: .constant(false) )

    }
}
