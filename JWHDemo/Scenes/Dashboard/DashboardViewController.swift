//
//  DashboardViewController.swift
//  JWHDemo
//
//  Created by Julian Hays on 12/6/18.
//  Copyright © 2018 orbosphere. All rights reserved.
//

import Foundation
import UIKit

class DashboardViewController : UIViewController {
  
  let viewModel = DashboardViewModel()
  
  @IBOutlet weak var welcomeLabel: UILabel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  // MARK: - Setup
  private func setupView() {
    guard let user = viewModel.user else {
      navigateToLogin()
      return
    }
    
    let welcomeText = "Welcome, \(user.firstName) \(user.lastName)"
    welcomeLabel?.text = welcomeText
  }
  
  // MARK: - Actions
  @IBAction func signOutPressed(_ sender: Any) {
    navigateToLogin()
  }
  
  // MARK: - Navigation
  private func navigateToLogin() {
    navigationController?.popToRootViewController(animated: true)
  }
  
}
