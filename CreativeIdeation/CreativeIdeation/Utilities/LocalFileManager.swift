//
//  LocalFileManager.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-11-14.
//

import SwiftUI
import UIKit

class LocalFileManager {

    static let instance = LocalFileManager()
    private init() {} // Singleton

    func saveImagetoFileManager(image: UIImage, imageName: String, folderName: String) {
        //  check if a folder needs to be created
        createFolderIfNeeded(folderName: folderName)

        // get path for image
        guard
            let imageData = image.jpegData(compressionQuality: 1),  // compresses to jpegData
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }

        // save image to path
        do {
            try imageData.write(to: url) // writes to file manager
        } catch let err {
            print("error saving image to file manager\(err)")
        }

    }

    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let
                url = getURLForImage(imageName: imageName, folderName: folderName), // check if get can get url and if file manager exsits
              FileManager.default.fileExists(atPath: url.path) else {
                  return nil

              }

        return UIImage(contentsOfFile: url.path)
    }

    // will create folder if no folder exists
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLforFolder(folderName: folderName) else { return }

        // check if folder exisits - if folder does not exist create one
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let err {
                print("Error creating directory. FolderName was not able to  be created \(err.localizedDescription) at \(folderName) ")
            }
        }
    }

    private func getURLforFolder(folderName: String) -> URL? {
     
        // saving images to the cachesDirectory for temporary storage
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }

        // appending folder name and returning url we are looking for
        return url.appendingPathComponent(folderName)
    }

    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        // get the folder name
        guard let folderURL = getURLforFolder(folderName: folderName) else { // if failed to unwrap we return nil
            print("failed to unwrap folderURL")
            return nil
        }
        // return the image path
        return folderURL.appendingPathComponent(imageName + ".jpeg")
    }

}
