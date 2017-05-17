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
  
  // MARK: - Objects
  
  enum FileError: Error {
    case couldNotFindMainScreen
    case couldNotParseImage
  }
  
  // MARK: - Properties
  
  lazy var apodImageURL: URL = {
    return self.apodDirectoryURL.appendingPathComponent("apodImage.png")
  }()
  
  // MARK: - Private Properties
  
  private let fileManager: FileManager
  
  private lazy var apodDirectoryURL: URL = {
    return self.fileManager.urls(for: .downloadsDirectory, in: .userDomainMask).first!.appendingPathComponent(".apodImages", isDirectory: true)
  }()
  
  // MARK: - Initialization
  
  init(fileManager: FileManager = FileManager.default) {
    self.fileManager = fileManager
  }
  
  // MARK: - Functions
  
  func createAPODDirectory() {
    do {
      try fileManager.createDirectory(at: apodDirectoryURL, withIntermediateDirectories: false, attributes: nil)
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
    guard let tiffData = image.tiffRepresentation else { throw FileError.couldNotParseImage }
    let imageRep = NSBitmapImageRep(data: tiffData)
    guard let imageData = imageRep?.representation(using: .PNG, properties: [:]) else { throw FileError.couldNotParseImage }
    try imageData.write(to: apodImageURL)
  }
  
  func updateDesktopImageWithSavedAPOD() throws {
    guard let mainScreen = NSScreen.screens()?.first else { throw FileError.couldNotFindMainScreen }
    try NSWorkspace.shared().setDesktopImageURL(apodImageURL, for: mainScreen, options: [:])
  }
}
