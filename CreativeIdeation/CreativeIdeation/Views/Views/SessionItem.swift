//
//  SessionItem.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct SessionItem: View {
    
    var title: String = "Example Title"
    var activity: String = "Example Activity"
    var date: String = "25-Feb-2021"
    var inProgress: Bool = true
    
    var body: some View {
        HStack{
            Text(title)
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            Text(activity)
                .font(.title3)
                .frame(width: 180, alignment: .leading)
            
            Text(date)
                .font(.title3)
                .frame(width: 140, alignment: .leading)
            
            Text(inProgress ? "In Progress" : "Completed")
                .font(.title3)
                .frame(width: 110)
                .foregroundColor(inProgress ? Color.black : Color.white)
                .padding()
                .background(inProgress ? Color.yellow : Color("darkCyan"))
                .cornerRadius(50)
                .padding()
            
            Button{
                // open activity settings
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.gray)
                    .padding()
            }
        }
    }
}

struct SessionItem_Previews: PreviewProvider {
    static var previews: some View {
        SessionItem()
    }
}
