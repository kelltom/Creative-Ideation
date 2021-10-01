//
//  SessionSettings.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-09-30.
//

import SwiftUI

struct SessionSettings: View {
    @Binding var showSheet: SessionSheet?
    @EnvironmentObject var sessionViewModel: SessionViewModel

    var body: some View {
        
        ZStack {
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
            GeometryReader { geometry in
                VStack(alignment:.center){
                    
                    Text("Sessions Settings")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    VStack(alignment: .leading) {

                        Text("Profanity Log")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.top)
                            .padding()
                        
                        List{
                            Text("test")
                            Text("test1")
                            Text("test1")
                            
                        }

                        Divider()
                            .frame(width: geometry.size.width * 0.7)
                            .background(Color("FadedColor"))

                    }
                    .frame(maxWidth: geometry.size.width * 0.7, maxHeight: 500)

                }
                .frame(maxWidth:.infinity, alignment: .center)
            }
        }
        
    }
}

struct SessionSettings_Previews: PreviewProvider {
    static var previews: some View {
        SessionSettings(showSheet: .constant(.settings))
            .environmentObject(SessionViewModel())
    }
}
