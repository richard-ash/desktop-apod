//
//  ViewController.swift
//  APODDeskotopImage
//
//  Created by Richard Ash on 1/2/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

  
  let apodFileManager = APODFileManager()
  let apiClient = APIClient()
  
  // MARK: - Overridden Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateDesktopBackgroundWithAPOD()
  }

  override var representedObject: Any? {
    didSet {
    }
  }
  
  // MARK: - Functions
  
  func updateDesktopBackgroundWithAPOD() {
    guard let imageURL = apiClient.getAPODImageURL() else { return }
    
    apiClient.downloadImage(from: imageURL) { [weak self] (image) in
      guard let strongSelf = self else { return }
      guard let image = image else { return }
      
      
      strongSelf.apodFileManager.createAPODDirectory()
      strongSelf.apodFileManager.removeAPODFile()
      strongSelf.apodFileManager.saveAPODImage(image)
      strongSelf.apodFileManager.updateDesktopImageWithAPOD()
    }
  }
}
