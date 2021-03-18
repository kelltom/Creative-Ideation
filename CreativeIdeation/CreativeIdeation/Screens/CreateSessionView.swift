//
//  CreateSessionView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct CreateSessionView: View {
    @State var sessionName: String = ""
    
    
    var body: some View {
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
                
                Button{
                    // do something here
                } label:{
                    BigButton(title: "Start").padding()
                }
            }
        }
    }
}

struct CreateSessionView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSessionView()
    }
}
