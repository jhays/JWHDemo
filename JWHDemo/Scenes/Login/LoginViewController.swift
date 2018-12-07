//
//  ViewController.swift
//  JWHDemo
//
//  Created by Julian Hays on 12/4/18.
//  Copyright © 2018 orbosphere. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  let viewModel = LoginViewModel()
  
  @IBOutlet weak var gradientView: GradientView?
  @IBOutlet weak var orbosphereNameImageView: UIImageView?
  @IBOutlet weak var orbosphereSImageView: UIImageView? 
  @IBOutlet weak var emailField: UITextField?
  @IBOutlet weak var emailInvalidIcon: UIImageView?
  @IBOutlet weak var emailInvalidLabel: UILabel?
  @IBOutlet weak var passwordField: UITextField?
  @IBOutlet weak var passwordInvalidIcon: UIImageView?
  @IBOutlet weak var passwordInvalidLabel: UILabel?
  @IBOutlet weak var signInButton: UIButton?
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
  
  private var initialLoad = true
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupViewModel()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // If its the first appearance, animate logo
    if initialLoad {
      initialLoad = false
      animateLogo()
    }
  }
  
  // MARK: - Setup
  private func setupView() {
    
    //add a tap gesture on the view to dismiss keyboard
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard))
    gradientView?.addGestureRecognizer(tapGesture)
    
    //set delegates on UITextFields
    emailField?.delegate = self
    passwordField?.delegate = self
  }
  
  private func setupViewModel() {
    
    //show invalid field icons if needed
    viewModel.emailTextUpdated = { [weak self] emailValid in
      DispatchQueue.main.async {
        self?.emailInvalidIcon?.isHidden = emailValid
        self?.emailInvalidLabel?.isHidden = emailValid
      }
    }
    
    viewModel.passwordTextUpdated = { [weak self] passwordValid in
      DispatchQueue.main.async {
        self?.passwordInvalidIcon?.isHidden = passwordValid
        self?.passwordInvalidLabel?.isHidden = passwordValid
      }
    }
    
    //show alert if alertMessage is set
    viewModel.showAlert = { [weak self] () in
      DispatchQueue.main.async {
        if let message = self?.viewModel.alertMessage {
          self?.showAlert(message)
        }
      }
    }
    
    //show activity indicator when loading
    viewModel.updateLoadingStatus = { [weak self] () in
      DispatchQueue.main.async {
        let isLoading = self?.viewModel.isLoading ?? false
        if isLoading {
          self?.startSpinner()
        } else {
          self?.stopSpinner()
        }
      }
    }
    
    //advance to dashboard on successful login
    viewModel.advanceToDashboard = { [weak self] () in
      guard let dashboardViewController = self?.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController,
        let user = self?.viewModel.user else {
        return
      }
      DispatchQueue.main.async {
        dashboardViewController.viewModel.user = user
        self?.navigationController?.pushViewController(dashboardViewController, animated: true)
      }
    }
  }
  
  // MARK: - Actions
  @IBAction func signInButtonPressed(_ sender: Any) {
    
    //disable button until login attempt responds
    signInButton?.isEnabled = false
    
    viewModel.attemptLogin(email: emailField?.text, password: passwordField?.text) {
      DispatchQueue.main.async {
        self.signInButton?.isEnabled = true
      }
    }
  }
  
  // MARK: - Helpers
  private func showAlert(_ message: String) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  @objc
  private func hideKeyboard() {
    //hides keyboard after any area on the gradientView has been tapped
    view.endEditing(true)
  }
  
  private func startSpinner() {
    activityIndicator?.startAnimating()
  }
  
  private func stopSpinner() {
    activityIndicator?.stopAnimating()
  }
  
  private func animateLogo() {
    //fire rotation of S image
    orbosphereSImageView?.isHidden = false
    
    func rotate(index: Int, max: Int) {
      let animationOptions = (index == max) ? UIView.AnimationOptions.curveEaseOut : UIView.AnimationOptions.curveLinear
      let duration = (index == max) ? 0.4 : 0.2
      
      self.orbosphereSImageView?.transform = .identity
      UIView.animate(withDuration: duration,
                     delay: 0.0,
                     options: animationOptions,
                     animations: {
        let rotate = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.orbosphereSImageView?.transform = rotate
      }) { (rotationDone) in
        if index < max {
          rotate(index: index + 1, max: max)
        }
      }
    }
    
    rotate(index: 0, max: 7)
    
    // fade in name image after delay
    orbosphereNameImageView?.alpha = 0.0
    orbosphereNameImageView?.isHidden = false
    UIView.animate(withDuration: 1.0,
                   delay: 1.2,
                   options: .curveEaseOut,
                   animations: {
                    self.orbosphereNameImageView?.alpha = 1.0
    })
  }
}

//MARK: - UITextFieldDelegate Extension
extension LoginViewController : UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let textFieldString = textField.text, let swtRange = Range(range, in: textFieldString) {
      let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)
      
      if textField == emailField {
        viewModel.emailText = fullString
      } else if textField == passwordField {
        viewModel.passwordText = fullString
      }
    }
    
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == emailField {
      viewModel.emailText = textField.text
    } else if textField == passwordField {
      viewModel.passwordText = textField.text
    }
  }
}
