//
//  CreateGroupView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-25.
//

import SwiftUI

struct CreateGroupView: View {
    @State var groupName: String = ""
    @State var groupDescription: String = ""
    @State var code: String = ""
    
    @State var groupCode: String = ""
    @State var activeSheet: ActiveSheet?
    @State private var showBanner: Bool = false
    
    
    var body: some View {
        ZStack {
            if showBanner {
                CodeGeneratorView(code: code)
            }
            
            VStack{
                Text("Create Your Group").font(.system(size: 40, weight: .heavy)).padding()
                HStack{
                    
                    VStack{
                        
                        MenuTextField(title: "group name", input: $groupName)
                        
                        MenuTextField(title: "group description (optiona)", input: $groupDescription)
                        
                        
                        Button{
                            randomGen()
                            //groupCode = UUID().uuidString
                            //print(groupCode)
                            //activeSheet = .group
                            withAnimation {
                                showBanner = true
                            }
                            delayAlert()
        
                            
                        } label:{
                            BigButton(title: "Create").padding()
                        }
                        
                        
                    }
                    
                }.padding() // padding padding for title
                
            }
        }
    }
    
    func randomGen(){
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        code = ""
        for _ in 1...6{
            code.append(letters.randomElement()!)
        }
        
        print(code)
     
    }
    
    private func delayAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            withAnimation{
                showBanner = false
            }
        }
    }
}






struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView()
    }
}


struct Student: Identifiable {
    var name: String
    var id = UUID()
}


