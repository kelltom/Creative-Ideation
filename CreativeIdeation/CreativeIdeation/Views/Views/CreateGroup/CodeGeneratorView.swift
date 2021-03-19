//
//  CodeGeneratorView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-19.
//

import SwiftUI

struct CodeGeneratorView: View {
    
    @State var code: String
    @Binding var showSheets: ActiveSheet?
    
    var body: some View {
        
        ZStack {
            VStack {
                Text("Group Code")
                    .font(.system(size: 35))
                    .foregroundColor(Color.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding()
                
                
                VStack {
                    Text(code)
                        .font(.system(size: 25))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                }
                .padding()
                .frame(width: 400, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .border(Color.white, width: 1.0)
                .background(Color.white)
                
            }
            .frame(maxWidth: 600, maxHeight: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .overlay(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke(Color("brandPrimary"), lineWidth: 2.5))
            .background(Color("brandPrimary"))
            .cornerRadius(25.0)
        }
        
    }
//
//    func randomGen(){
//        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        code = ""
//        for _ in 1...6{
//            code.append(letters.randomElement()!)
//        }
//
//        print(code)
//
//    }
//
    
}

struct CodeGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        CodeGeneratorView(code: "", showSheets: .constant(.addTeamMembers))
    }
}
