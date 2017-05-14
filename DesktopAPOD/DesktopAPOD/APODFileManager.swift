//
//  APODFileManager.swift
//  APODDesktopImage
//
//  Created by Richard Ash on 3/29/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Foundation
import Cocoa

class APODFileManager {
  
  // MARK: - Variables
  
  lazy var apodImageURL: URL = {
    return self.apodDirectoryURL.appendingPathComponent("apodImage.png")
  }()
  
  // MARK: - Private Functions
  
  private let fileManager = FileManager.default
  private let apodDirectoryURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".APODImages", isDirectory: true)
  
  // MARK: - Functions
  
  func createAPODDirectory() {
    do {
      try FileManager.default.createDirectory(at: apodDirectoryURL, withIntermediateDirectories: false, attributes: nil)
    } catch {
      NSLog("Failed to create directory: \(error)")
    }
  }
  
  func removeAPODFile() {
    do {
      try fileManager.removeItem(at: apodImageURL)
    } catch {
      NSLog("Failed to remove image: \(error)")
    }
  }
  
  func saveAPODImage(_ image: NSImage) throws {
    guard let tiffData = image.tiffRepresentation else { return }
    let imageRep = NSBitmapImageRep(data: tiffData)
    guard let imageData = imageRep?.representation(using: .PNG, properties: [:]) else { return }
    try imageData.write(to: apodImageURL)
  }
  
  func updateDesktopImageWithSavedAPOD() throws {
    guard let mainScreen = NSScreen.screens()?.first else { return }
    try NSWorkspace.shared().setDesktopImageURL(apodImageURL, for: mainScreen, options: [:])
  }
}
