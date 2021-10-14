//
//  CodeGeneratorView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-19.
//

import CoreImage.CIFilterBuiltins
import SwiftUI
import UIKit

struct TeamCodeSheet: View {

    @Binding var showSheets: ActiveSheet?
    @State var isCopied: Bool = false
    @State var showShareSheet: Bool = false
    @EnvironmentObject var teamViewModel: TeamViewModel

    // Stores Core Image context
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State var qrImage = UIImage()

    var body: some View {

        GeometryReader { geometry in
            ZStack {

                Color("BackgroundColor")

                VStack {
                    XDismissButton(isShowingSheet: $showSheets)
                    Spacer()
                }

                // Main sheet contents
                VStack {

                    Spacer()

                    // Written Team access code
                    VStack {
                        Text("Team Access Code")
                            .font(.largeTitle)
                            .foregroundColor(Color(.white))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding()

                        VStack {
                            HStack {
                                Spacer()
                                Text(teamViewModel.selectedTeam?.accessCode ?? "Select a team")
                                    .font(.title)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                Spacer()
                                Button {
                                    // needs to copy to users keyboard
                                    UIPasteboard.general.string = teamViewModel.selectedTeam?.accessCode
                                        isCopied = true
                                }label: {
                                    Image(systemName: "doc.on.doc")

                                }
                            }
                        }
                        .padding()
                        .frame(width: 400, height: 80, alignment: .center)
                        .border(Color.white, width: 1.0)
                        .background(Color("BackgroundColor"))

                        ZStack {
                            if isCopied {
                                Text("Copied to clipboard!").foregroundColor(.white)
                            }
                        }
                    }
                    .frame(maxWidth: geometry.size.width * 0.75, maxHeight: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(Color("brandPrimary"), lineWidth: 2.5)
                    )
                    .background(Color("brandPrimary"))
                    .cornerRadius(25.0)

                    Spacer()

                    // QR Code section
                    VStack {
                        Image(uiImage: generateQRCode(from: teamViewModel.selectedTeam?.accessCode ?? ""))
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5)

                        Button {
                            self.showShareSheet = true
                        } label: {
                            HStack {
                                Text("Share")
                                    .fontWeight(.bold)
                                    .font(.title2)
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title)
                            }
                        }
                    }
                    Spacer()
                }
                .sheet(isPresented: $showShareSheet) {
                    ShareItems(activityItems: [generateQRCode(from: teamViewModel.selectedTeam?.accessCode ?? "")])
                }

            }
        }
    }

    /// Generates a QR code
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {

                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct CodeGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        TeamCodeSheet(showSheets: .constant(.addTeamMembers))
            .environmentObject(TeamViewModel())
    }
}
