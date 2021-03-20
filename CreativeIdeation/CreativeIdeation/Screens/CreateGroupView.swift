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
    @Binding var showSheets: ActiveSheet?

    var body: some View {
        
        ZStack {
            
            VStack {
                XDismissButton(isShowingSheet: $showSheets)
                Spacer()
            }
            
            VStack{
                
                Text("Create Your Group").font(.system(size: 40, weight: .heavy)).padding()
                
                HStack{
                    
                    VStack{
                        
                        MenuTextField(title: "group name", input: $groupName)
                        
                        MenuTextField(title: "group description (optiona)", input: $groupDescription)
                        
                        Button {
                            //
                        } label: {
                            BigButton(title: "Create").padding()
                        }
                    }
                    
                }
                .padding() // padding padding for title
            }
        }
    }
}


struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView(showSheets: .constant(.group))
    }
}


