//
//  APOD.swift
//  DesktopAPOD
//
//  Created by Richard Ash on 4/29/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Foundation
import Cocoa

class APOD: NSObject, NSCoding {
  
  // MARK: - Static Properties
  
  private static let Keys = (
    apodImage: "apodImage",
    lastRefresh: "lastRefresh"
  )
  
  // MARK: - Properties
  
  let image: NSImage
  let lastRefresh: Date
  
  lazy var formattedDate: String = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .long
    return dateFormatter.string(from: self.lastRefresh)
  }()
  
  // MARK: - Initialization
  
  init(image: NSImage, date: Date) {
    self.image = image
    self.lastRefresh = date
  }
  
  required init?(coder aDecoder: NSCoder) {
    guard let image = aDecoder.decodeObject(forKey: APOD.Keys.apodImage) as? NSImage else { return nil }
    guard let lastRefresh = aDecoder.decodeObject(forKey: APOD.Keys.lastRefresh) as? Date else { return nil }
    
    self.image = image
    self.lastRefresh = lastRefresh
  }
  
  // MARK: - NS Coding Methods
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(image, forKey: APOD.Keys.apodImage)
    aCoder.encode(lastRefresh, forKey: APOD.Keys.lastRefresh)
  }
}

