//
//  APIClient.swift
//  APODDesktopImage
//
//  Created by Richard Ash on 3/28/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Cocoa
import Foundation
import Kanna

class APIClient {
  
  // MARK: - Variables
  
  private let session: URLSession
  
  // MARK: - Init
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  // MARK: - Functions
  
  func downloadImage(from url: URL, completion: @escaping (NSImage?) -> Void) {
    let task = session.dataTask(with: url, completion: { (result) in
      switch result {
      case let .success(data):
        completion(NSImage(data: data))
      case let .failure(error):
        NSLog("\(error)")
        completion(nil)
      }
    })
    task.resume()
  }
  
  func getAPODImageURL() -> URL? {
    let base = "https://apod.nasa.gov/apod/"
    guard let url = URL(string: base) else { return nil }
    guard let htmlString = try? String(contentsOf: url) else { return nil }
    guard let doc = HTML(html: htmlString, encoding: .utf8) else { return nil }
    guard let partialImageURL = doc.css("a, center").flatMap({ $0["href"] }).filter({ $0.contains("image") }).first else { return nil }
    guard let imageURL = URL(string: base + partialImageURL) else { return nil }
    return imageURL
  }
}
