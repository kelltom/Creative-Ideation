//
//  JoinTeamView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-04-13.
//

import CodeScanner
import SwiftUI

struct JoinTeamSheet: View {

    @State private var showBanner: Bool = false
    @Binding var showSheets: ActiveSheet?
    @State var code: String = ""
    @EnvironmentObject var teamViewModel: TeamViewModel
    @EnvironmentObject var userTeamModel: UserAccountViewModel

    // To handle QR scanning
    @State private var isShowingScanner = false

    var body: some View {

        ZStack {

            Color("BackgroundColor")

            if teamViewModel.isShowingBanner {
                if teamViewModel.didOperationSucceed {
                    NotificationBanner(image: "checkmark.circle.fill", msg: teamViewModel.msg, color: .green)
                } else {
                    NotificationBanner(image: "exclamationmark.circle.fill", msg: teamViewModel.msg, color: .red)
                }
            }
            VStack {
                XDismissButton(isShowingSheet: $showSheets)
                Spacer()
            }
            GeometryReader { geometry in

                VStack {
                    Text("Join a Team ")
                        .font(.system(size: 40))
                        .padding()

                    VStack(alignment: .leading) {
                        Text("Enter Your Team Code")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.leading)

                        // Text area
                        ZStack {
                            EditTextField(title: "Team Code", input: $code, geometry: geometry, widthScale: 0.75)

                            HStack {

                                Spacer()

                                // QR scan button
                                Button {
                                    self.isShowingScanner = true
                                } label: {
                                    Image(systemName: "qrcode.viewfinder")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .padding(.trailing, 20)
                                        .foregroundColor(Color("StrokeColor"))
                                }
                            }
                        }
                        .frame(width: geometry.size.width * 0.75, height: 60)
                    }

                    Button {
                        teamViewModel.joinTeam(code: code)
                        code = ""
                    } label: {
                        BigButton(title: "Join", geometry: geometry, widthScale: 0.75)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan)
        }
    }

    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false

        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            self.code = details[0]
        case .failure(let error):
            print("Scanning failed: ", error)
        }
    }
}

struct JoinTeamView_Previews: PreviewProvider {
    static var previews: some View {
        JoinTeamSheet(showSheets: .constant(.joinTeam))
            .preferredColorScheme(.dark)
            .environmentObject(TeamViewModel())
    }
}
