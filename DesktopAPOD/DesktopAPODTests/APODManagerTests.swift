//
//  APODManagerTests.swift
//  APODDesktopImage
//
//  Created by Richard Ash on 1/3/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import XCTest
@testable import DesktopAPOD

class APODManagerTests: XCTestCase {
  
  // MARK: - Properties
  
  var apodImageManager: APODFileManager!
  let apodDirectoryURL: URL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".APODImages", isDirectory: true)
  
  // MARK: - Overridden Methods
  
  override func setUp() {
    super.setUp()
    apodImageManager = APODFileManager()
  }
  
  // MARK: - Test Methods
  
//  func testFindAPODDirectoryReturnsCorrectURL() {
//    let returnedURL = apodImageManager.apodDirectoryURL
//    
//    XCTAssertEqual(returnedURL, apodDirectoryURL)
//  }
  
  func testAPODDirectoryExistsAtURL() {
    let mockImageManager = MockAPODImageManager()
    
    mockImageManager.createAPODDirectory()
    
    XCTAssert(mockImageManager.directoryCreated)
  }
  
//  func testGetAPODImageURL() {
//    let returnedURL = apodImageManager.getAPODImageURL()
//    
//    XCTAssertNotNil(returnedURL)
//  }

  
  
}

extension APODManagerTests {
  class MockAPODImageManager: APODFileManager {
    var directoryCreated = false
    
    override func createAPODDirectory() {
      directoryCreated = true
    }
  }
}
