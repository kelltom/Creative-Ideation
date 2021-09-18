//
//  UpdateTeamDescriptionSheet.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-09-18.
//

import SwiftUI

struct UpdateTeamDescriptionSheet: View {
    @State var newEmail: String = ""
    @State var currentEmail: String = ""
    @State var currentPasword: String = ""
    @State private var widthScale: CGFloat = 0.75
    @Binding var showSheet: EditSheet?
    
    @EnvironmentObject var teamViewModel: TeamViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct UpdateTeamDescriptionSheet_Previews: PreviewProvider {
    static var previews: some View {
        UpdateTeamDescriptionSheet(showSheet: .constant(.description))
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            .environmentObject(TeamViewModel())
    }
}
