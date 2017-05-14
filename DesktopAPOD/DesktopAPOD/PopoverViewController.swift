//
//  PopoverViewController.swift
//  DesktopAPOD
//
//  Created by Richard Ash on 4/29/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Cocoa

protocol PopoverViewControllerDelegate {
  func popoverViewController(_ popoverViewController: PopoverViewController, settingsWasTapped button: NSButton?)
}

class PopoverViewController: NSViewController {
  
  // MARK: - Static Properties
  
  static let identifier = "PopoverViewController"
  
  // MARK: - IB Outlet Properties
  
  @IBOutlet weak var imageView: NSImageView!
  @IBOutlet weak var dateTextField: NSTextField!
  @IBOutlet weak var refreshButton: NSButton!
  @IBOutlet weak var backgroundButton: BackgroundButton!
  @IBOutlet weak var spinner: Spinner!
  
  // MARK: - Properties
  
  var apiClient: APIClient!
  var apodFileManager: APODFileManager!
  var apod = APOD.loadAPOD()
  var delegate: PopoverViewControllerDelegate?
  
  // MARK: - Overridden Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.layer?.backgroundColor = NSColor.black.cgColor
    spinner.isHidden = true

    if let apod = apod {
      configureUI(with: apod)
    } else {
      refreshAPOD()
    }
  }
  
  // MARK: - IB Action Methods
  
  @IBAction func refresh(_ sender: Any?) {
    if spinner.isHidden {
      spinner.showAnimated()
      refreshAPOD()
    }
  }
  
  @IBAction func goToSettings(_ sender: NSButton?) {
    if let apod = apod {
      APOD.save(apod)
    }
    
    delegate?.popoverViewController(self, settingsWasTapped: sender)
  }
  
  @IBAction func updateBackground(_ sender: NSButton?) {
    if let apod = apod {
      self.updateDesktopBackground(with: apod)
    }
  }
  
  // MARK: - Methods
  
  func configureUI(with apod: APOD) {
    imageView.image = apod.image
    dateTextField.stringValue = apod.formattedDate
  }
  
  func refreshAPOD() {
    getAPOD { [weak self] (apod) in
      self?.apod = apod
      DispatchQueue.main.async {
        self?.configureUI(with: apod)
        self?.spinner.hideAnimated()
      }
    }
  }
  
  func updateDesktopBackground(with apod: APOD) {
    apodFileManager.createAPODDirectory()
    apodFileManager.removeAPODFile()
    
    do {
      try apodFileManager.saveAPODImage(apod.image)
      try apodFileManager.updateDesktopImageWithSavedAPOD()
    } catch {
      backgroundButton.animateUpdateFailed()
    }
    
    backgroundButton.animateUpdateSucceeded()
  }
  
  // MARK: - Private Methods
  
  private func getAPOD(completion: @escaping (APOD) -> Void) {
    guard let imageURL = apiClient.getAPODImageURL() else { return }
    
    apiClient.downloadImage(from: imageURL) { (image) in
      guard let image = image else { return }
      let apod = APOD(image: image, date: Date())
      completion(apod)
    }
  }
}
