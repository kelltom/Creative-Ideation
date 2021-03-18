//
//  ActivityView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI

struct ActivityView: View {
    
    let columns = [GridItem(.adaptive(minimum: 900))]
    
    var body: some View {
        ZStack{
            // Whatever view we use for the canvas will be placed here, so that all other elements are placed above it on the zstack
            
            HStack{
                ActivityToolbar()
                Spacer()
                VStack{
                    ActiveMembers()
                    Spacer()
                }
                .hidden()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
