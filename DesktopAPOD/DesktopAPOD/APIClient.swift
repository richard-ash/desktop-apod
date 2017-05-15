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
  
  // MARK: - Objects
  
  enum APIError: Error {
    case noImage
    case cannontParseHTML
    case cannotFindApodURL
    case other(String)
  }
  
  // MARK: - Properties
  
  private let session: URLSession
  
  // MARK: - Initialization
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  // MARK: - Methods
  
  func downloadImage(from url: URL, completion: @escaping (NSImage?) -> Void) {
    let task = session.dataTask(with: url, completion: { (result) in
      switch result {
      case let .success(data):
        completion(NSImage(data: data))
      case let .failure(error):
        NSLog("Network Error: \(error)")
        completion(nil)
      }
    })
    task.resume()
  }
  
  func getAPODImageURL() -> Result<URL> {
    let base = "https://apod.nasa.gov/apod/"
    guard let url = URL(string: base) else { return .failure(APIError.cannotFindApodURL) }
    guard let htmlString = try? String(contentsOf: url) else { return .failure(APIError.cannontParseHTML) }
    guard let doc = HTML(html: htmlString, encoding: .utf8) else { return .failure(APIError.cannontParseHTML) }
    guard let partialImageURL = doc.css("a, center").flatMap({ $0["href"] }).filter({ $0.contains("image") }).first else { return .failure(APIError.noImage) }
    guard let imageURL = URL(string: base + partialImageURL) else { return .failure(APIError.cannontParseHTML) }
    return .success(imageURL)
  }
}
