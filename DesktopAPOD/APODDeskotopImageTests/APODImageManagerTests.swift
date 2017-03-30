//
//  APODImageManagerTests.swift
//  APODDeskotopImage
//
//  Created by Richard Ash on 1/3/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import XCTest
@testable import APODDesktopImage

class APODImageManagerTests: XCTestCase {
  
  var apodImageManager: APODImageManager!
  let apodDirectoryURL: URL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("APODImages", isDirectory: true)
  
  override func setUp() {
    super.setUp()
    apodImageManager = APODImageManager()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testFindAPODDirectoryReturnsCorrectURL() {
    let returnedURL = apodImageManager.apodDirectoryURL
    
    XCTAssertEqual(returnedURL, apodDirectoryURL)
  }
  
  func testAPODDirectoryExistsAtURL() {
    let mockImageManager = MockAPODImageManager()
    
    mockImageManager.createAPODDirectory()
    
    XCTAssert(mockImageManager.directoryCreated)
  }
  
  func testGetAPODImageURL() {
    let returnedURL = apodImageManager.getAPODImageURL()
    
    XCTAssertNotNil(returnedURL)
  }

  
  
}

extension APODImageManagerTests {
  class MockAPODImageManager: APODImageManager {
    var directoryCreated = false
    
    override func createAPODDirectory() {
      directoryCreated = true
    }
  }
}
