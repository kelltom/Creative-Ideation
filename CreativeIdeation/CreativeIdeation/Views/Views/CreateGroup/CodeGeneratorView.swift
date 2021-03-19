//
//  CodeGeneratorView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-19.
//

import SwiftUI

struct CodeGeneratorView: View {
    
    @State var code: String = "AFT6GH4"
    var body: some View {
        
        VStack {
            Text("Group Code")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color("brandPrimary"))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding()
            
            VStack {
                Text(code)
                    
            }
            .frame(width: 400, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .border(Color.black, width: 1.0)
    
        }
        .frame(maxWidth: 600, maxHeight: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .overlay(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke(Color.black, lineWidth: 2.5))
        
        
      
    
    }
}

struct CodeGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        CodeGeneratorView()
    }
}
