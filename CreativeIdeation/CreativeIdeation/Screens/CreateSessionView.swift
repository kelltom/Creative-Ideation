//
//  CreateSessionView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct CreateSessionView: View {
    @State var sessionName: String = ""
    @Binding var showSheets: ActiveSheet?
    @Binding var showActivity: Bool
    
    
    var body: some View {
        ZStack {
            
            VStack {
                XDismissButton(isShowingSheet: $showSheets)
                Spacer()
            }
            
            VStack{
                Text("Create a Session").font(.system(size: 40, weight: .heavy)).padding()
                
                VStack{
                    MenuTextField(title: "Session Name", input: $sessionName)
                    
                    HStack{
                        ActivityTypeTile(selected: true)
                            .padding()
                        ActivityTypeTile(
                            title: "Sticky Notes", symbol_name: "doc.on.doc.fill")
                            .padding()
                    }
                    
                    Button {
                        showSheets = nil
                        showActivity = true
                    } label: {
                        BigButton(title: "Start").padding()
                    }
                }
            }
        }
    }
}

struct CreateSessionView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSessionView(showSheets: .constant(.session), showActivity: .constant(false))
    }
}
