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
        Text("this is session preference")
    }
}

struct SessionSettings_Previews: PreviewProvider {
    static var previews: some View {
        SessionSettings(showSheet: .constant(.settings))
            .environmentObject(SessionViewModel())
    }
}
