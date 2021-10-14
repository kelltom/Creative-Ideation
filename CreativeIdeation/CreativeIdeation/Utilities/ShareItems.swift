//
//  ShareItems.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-10-13.
//

import Foundation
import SwiftUI
import UIKit

struct ShareItems: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]?
    @State var isSaving: Bool = false

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareItems>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)

        controller.completionWithItemsHandler = { (_: UIActivity.ActivityType?, completed: Bool, _: [Any]?, error: Error?) in
            if completed {
                print("share completed")
                self.isSaving = true
                return
            } else {
                print("cancel")
            }
            if let shareError = error {
                print("error while sharing: \(shareError.localizedDescription)")
            }
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareItems>) {}

}
