//
//  UserPrefView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI
import FirebaseStorage

enum PreferenceSheet: Identifiable {
    case name, email, password

    var id: Int {
        hashValue
    }
}

struct UserSettingsView: View {

    @EnvironmentObject var userAccountViewModel: UserAccountViewModel
    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel

    @State var showSheet: PreferenceSheet?
    @State private var darkModeFilter = true

    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var sourceType: String?

    @Binding var showUserSettings: Bool

    var userName: String = ""
    var email: String = ""
    var password: String = "*********"

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            // Back button required, as NavigationView not used to get to this page
            BackButton(text: "Home", binding: $showUserSettings)

            GeometryReader { geometry in
                VStack {

                    Text("User Settings")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                        .padding(.top, 20)  // Added to make heading position consistent with other settings screens that have custom back buttons

                    VStack {
                        VStack {
                            ZStack {

                                if userAccountViewModel.currentImage != nil {
                                    userAccountViewModel.currentImage?
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())

                                } else {
                                    ProfilePic(size: 40, image: "person.fill")

                                }
                                Image(systemName: "plus")
                                    .foregroundColor(Color.blue)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .contextMenu {
                                        Button {
                                            self.showImagePicker = true

                                        } label: {
                                            HStack {
                                                Text("Choose Image")
                                                Image(systemName: "square.and.arrow.up")
                                            }
                                        }
                                        Button {

                                            self.showImagePicker.toggle()
                                        } label: {
                                            HStack {
                                                Text("Open Camera")
                                                Image(systemName: "camera")
                                            }
                                        }
                                    }

                            }
                        }

                        VStack(alignment: .leading ) {

                            Text("Full Name")
                                .font(.title3)
                                .fontWeight(.bold)

                            HStack {
                                Text(userAccountViewModel.selectedUser?.name ?? "Unknown")
                                    .font(.title3)

                                Spacer()
                                // edit button for name
                                Button {
                                    showSheet = .name
                                } label: {
                                    // button design
                                    TextEditButton()
                                }

                            }

                            Text("Email")
                                .font(.title3)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                            HStack {
                                Text(userAccountViewModel.selectedUser?.email ?? "Unknown")
                                    .font(.title3)

                                Spacer()
                                // email text button
                                Button {
                                    showSheet = .email
                                } label: {
                                    // button design
                                    TextEditButton()
                                }
                            }

                            Text("Password")
                                .font(.title3)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                            HStack {
                                Text(password)
                                    .font(.title3)

                                Spacer()

                                Button { // edit button for password
                                    showSheet = .password
                                } label: {
                                    // button design
                                    TextEditButton()
                                }
                            }

                        }
                        .padding()
                        .frame(width: geometry.size.width * 0.7, alignment: .leading)
                        .background(Color("BackgroundColor"))
                        .cornerRadius(20)
                    }
                    .frame(width: geometry.size.width * 0.75, alignment: .center)
                    .padding(.bottom)
                    .background(Color("brandPrimary"))
                    .cornerRadius(20)

                    Spacer()

                    // LogOutButton
                    Button {
                        userAccountViewModel.signOut()
                        teamViewModel.clear()
                        groupViewModel.clear()
                    } label: {
                        LogOutButton()
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .sheet(item: $showSheet) { item in
                    switch item {

                    case .email:
                        UpdateEmailSheet(showSheet: $showSheet)
                            .environmentObject(self.userAccountViewModel)

                    case .password:
                        UpdatePasswordSheet(showSheet: $showSheet) .environmentObject(self.userAccountViewModel)

                    case .name:
                        UpdateNameSheet(showSheet: $showSheet)
                            .environmentObject(self.userAccountViewModel)

                    }
                }
                .onAppear {
                    userAccountViewModel.getCurrentUserInfo()

                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: self.$inputImage)
                // PhotoPicker(pickerResult: self.$inputImage, isPresented: self.$showImagePicker)

            }
        }
    }

    func loadImage() {
        guard let inputImage = self.inputImage else { return }
        guard let currentUser = userAccountViewModel.selectedUser?.id else {return}
        if let imageData = inputImage.jpegData(compressionQuality: 1) {

            let storage = Storage.storage()
            storage.reference().child(currentUser).putData(imageData, metadata: nil) {
                (_, err) in
                if let err = err {
                    print("error occured \(err.localizedDescription)")
                } else {
                    print("upload success")
                }
            }
        }
        userAccountViewModel.currentImage = Image(uiImage: inputImage)

    }

}

/// Enables the use of the ! operator on binding variables
prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}

struct UserPrefView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView(showUserSettings: .constant(true))
            .preferredColorScheme(.light)
            .environmentObject(UserAccountViewModel())
    }
}
