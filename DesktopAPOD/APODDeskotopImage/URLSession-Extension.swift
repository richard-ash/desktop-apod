//
//  URLSession-Extension.swift
//  APODDesktopImage
//
//  Created by Richard Ash on 3/28/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Foundation

enum URLSessionError: Error {
  case unknown(URLResponse?)
}

extension URLSession {
  func dataTask(with url: URL, completion: @escaping (Result<Data>) -> Void) -> URLSessionDataTask {
    return self.dataTask(with: url) { (data, response, error) in
      if let error = error, data == nil {
        completion(.failure(error))
      } else if let data = data, error == nil {
        completion(.success(data))
      } else {
        completion(.failure(URLSessionError.unknown(response)))
      }
    }
  }
}
