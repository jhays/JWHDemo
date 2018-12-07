//
//  LoginViewModel.swift
//  JWHDemo
//
//  Created by Julian Hays on 12/5/18.
//  Copyright © 2018 orbosphere. All rights reserved.
//

import Foundation
class LoginViewModel {
  
  //MARK: - Public variables
  var isLoading: Bool = false {
    didSet {
      self.updateLoadingStatus?()
    }
  }
  
  var alertMessage: String? {
    didSet {
      self.showAlert?()
    }
  }
  
  var emailText: String? = nil {
    didSet {
      if let email = emailText {
        emailValid = validateEmail(email: email)
      }else {
        emailValid = false
      }
    }
  }
  
  var emailValid: Bool = false {
    didSet {
      emailTextUpdated?(emailValid)
    }
  }
  
  var passwordText: String? = nil {
    didSet {
      if let password = passwordText {
        passwordValid = validatePassword(password: password)
      }else {
        passwordValid = false
      }
    }
  }
  
  var passwordValid: Bool = false {
    didSet {
      passwordTextUpdated?(passwordValid)
    }
  }
  
  var user: User? = nil
  
  //MARK: - Binding closures
  var updateLoadingStatus: (()->())?
  var showAlert: (()->())?
  var advanceToDashboard: (()->())?
  var emailTextUpdated:((_ valid: Bool)->())?
  var passwordTextUpdated: ((_ valid:Bool)->())?
  
  //MARK: - Private variables
  private let apiService: APIServiceProtocol
  
  init( apiService: APIServiceProtocol = APIService()) {
    self.apiService = apiService
  }
  
  //MARK: - API Usage
  func attemptLogin(email:String?, password: String?, completion:@escaping()->()) {
    
    //Validate fields before attempting login
    emailText = email
    passwordText = password
    
    guard let email = email,
      let password = password else {
        completion()
        return
    }
    
    if email.isEmpty || password.isEmpty {
      completion()
      return
    }
    
    isLoading = true
    apiService.login(email: email, password: password) { [weak self] (success, user, error) in
      self?.isLoading = false
      if let error = error {
        self?.alertMessage = error.rawValue
      } else {
        self?.user = user
        self?.advanceToDashboard?()
      }
      completion()
    }
  }
  
  //MARK: - Field Validation
  private func validateEmail(email:String) -> Bool {
    return email.isValidEmail()
  }
  
  private func validatePassword(password: String) -> Bool {
    return !password.isEmpty
  }
}
