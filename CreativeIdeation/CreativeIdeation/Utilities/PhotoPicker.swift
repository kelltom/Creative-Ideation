//
//  PhotoPicker.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-11-12.
//

import SwiftUI
import UIKit
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
  @Binding var pickerResult: UIImage? // pass images back to the SwiftUI view
  @Binding var isPresented: Bool // close the modal view

  func makeUIViewController(context: Context) -> some UIViewController {
    var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
    configuration.filter = .images // filter only to images
    configuration.selectionLimit = 1

    let photoPickerViewController = PHPickerViewController(configuration: configuration)
    photoPickerViewController.delegate = context.coordinator // Use Coordinator for delegation

      return photoPickerViewController
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

    func makeCoordinator() -> Coordinator {
      Coordinator(self)
    }

    // Create the Coordinator, in this case it is a way to communicate with the PHPickerViewController
    class Coordinator: PHPickerViewControllerDelegate {
      private let parent: PhotoPicker

      init(_ parent: PhotoPicker) {
        self.parent = parent
      }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
          picker.dismiss(animated: true, completion: nil)

          results.forEach { result in
              result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                  if let error = error {
                      print(error.localizedDescription)
                      return
                  }
                  self.parent.pickerResult = object as? UIImage

//                  guard let uiImage = object as? UIImage else {
//                      print("unable to unwrap image as ui image - unable to read")
//                      return
//                  }
//                  print(uiImage)
//                  self.parent.pickerResult = uiImage as? UIImage
              }

          }
          parent.isPresented = false
      }
    }
}
