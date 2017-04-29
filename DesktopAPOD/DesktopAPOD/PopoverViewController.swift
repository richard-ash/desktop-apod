//
//  PopoverViewController.swift
//  DesktopAPOD
//
//  Created by Richard Ash on 4/29/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController {
  
  // MARK: - Static Properties
  
  static let identifier = "PopoverViewController"
  
  // MARK: - IB Outlet Properties
  
  @IBOutlet weak var imageView: NSImageView!
  @IBOutlet weak var dateTextField: NSTextField!
  @IBOutlet weak var refreshButton: NSButton!
  @IBOutlet weak var spinner: Spinner!
  
  // MARK: - Properties
  
  var apiClient: APIClient!
  var apodFileManager: APODFileManager!
  var apod: APOD?
  
  // MARK: - Overridden Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    refreshAPOD()
    
  }
  
  // MARK: - IB Action Methods
  
  @IBAction func refresh(_ sender: Any?) {
    if spinner.isHidden {
      spinner.showAnimated()
      refreshAPOD()
    }
  }
  
  @IBAction func quit(_ sender: Any?) {
    NSApplication.shared().terminate(sender)
  }
  
  // MARK: - Methods
  
  func configureUI(with apod: APOD) {
    imageView.image = apod.image
    dateTextField.stringValue = apod.formattedDate
  }
  
  func getAPOD(completion: @escaping (APOD) -> Void) {
    guard let imageURL = apiClient.getAPODImageURL() else { return }
    
    apiClient.downloadImage(from: imageURL) { (image) in
      guard let image = image else { return }
      let apod = APOD(image: image, date: Date())
      completion(apod)
    }
  }
  
  func updateDesktopBackground(with apod: APOD) {
    apodFileManager.createAPODDirectory()
    apodFileManager.removeAPODFile()
    apodFileManager.saveAPODImage(apod.image)
    apodFileManager.updateDesktopImageWithSavedAPOD()
  }
  
  // MARK: - Private Methods
  
  private func refreshAPOD() {
    getAPOD { [weak self] (apod) in
      // self?.updateDesktopBackground(with: apod)
      DispatchQueue.main.async {
        self?.configureUI(with: apod)
        self?.spinner.hideAnimated()
      }
    }
  }
  
  private func configureUI() {
    spinner.isHidden = true
  }
}
