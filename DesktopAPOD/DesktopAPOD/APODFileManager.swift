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
  
  // MARK: - Private Properties
  
  private let fileManager: FileManager
  
  private lazy var apodDirectoryURL: URL = {
    return self.fileManager.urls(for: .downloadsDirectory, in: .userDomainMask).first!.appendingPathComponent(".apodImages", isDirectory: true)
  }()
  
  // MARK: - Initialization
  
  init(fileManager: FileManager = FileManager.default) {
    self.fileManager = fileManager
  }
  
  // MARK: - Methods
  
  func createAPODDirectory() {
    do {
      try fileManager.createDirectory(at: apodDirectoryURL, withIntermediateDirectories: false, attributes: nil)
    } catch {
      NSLog("Failed to create directory: \(error)")
    }
  }
  
  func removeFilesFromAPODDirectory() {
    do {
      let directoryContents = try fileManager.contentsOfDirectory(atPath: apodDirectoryURL.path)
      for content in directoryContents {
        let contentPath = apodDirectoryURL.appendingPathComponent(content)
        removeFile(at: contentPath)
      }
    } catch {
      print("Could not remove files from APOD Directory: \(error)")
    }
  }
  
  func saveAPODImage(_ apod: APOD) throws {
    guard let tiffData = apod.image.tiffRepresentation else { throw FileError.couldNotParseImage }
    let apodPath = path(for: apod)
    let imageRep = NSBitmapImageRep(data: tiffData)
    guard let imageData = imageRep?.representation(using: .PNG, properties: [:]) else { throw FileError.couldNotParseImage }
    try imageData.write(to: apodPath)
  }
  
  func updateDesktopImage(from savedAPOD: APOD) throws {
    let apodPath = path(for: savedAPOD)
    guard let mainScreen = NSScreen.screens()?.first else { throw FileError.couldNotFindMainScreen }
    try NSWorkspace.shared().setDesktopImageURL(apodPath, for: mainScreen, options: [:])
  }
  
  // MARK: - Private Methods
  
  private func removeFile(at path: URL) {
    do {
      try fileManager.removeItem(at: path)
    } catch {
      print("Could not remove file at path: \(path)")
      print("Error: \(error)")
    }
  }
  
  private func path(for apod: APOD) -> URL {
    return apodDirectoryURL.appendingPathComponent("apodImage\(apod.title).png")
  }
}
