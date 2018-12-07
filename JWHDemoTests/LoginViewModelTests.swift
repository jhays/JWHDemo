//
//  LoginViewModelTests.swift
//  JWHDemoTests
//
//  Created by Julian Hays on 12/5/18.
//  Copyright © 2018 orbosphere. All rights reserved.
//

import XCTest
@testable import JWHDemo

class LoginViewModelTests: XCTestCase {

  var sut:LoginViewModel!
  var mockAPIService: MockAPIService!
  
  override func setUp() {
    super.setUp()
    mockAPIService = MockAPIService()
    sut = LoginViewModel(apiService: mockAPIService)
  }

  override func tearDown() {
    sut = nil
    mockAPIService = nil
    super.tearDown()
  }

  func test_login() {
    // Given valid account credentials
    let email = "test@test.com"
    let password = "test12345"
    
    // When
    sut.attemptLogin(email: email, password: password) {
      
    }
    
    // Assert
    XCTAssert(mockAPIService!.isLoginCalled)
    
  }
  
  func test_login_fail() {
    // Given a failed login error
    let error = APIError.permissionDenied
    
    // When
    sut.attemptLogin(email: "invalid@test.com", password: "invalid") {
      
    }
    
    mockAPIService.loginFail(error: error)
    
    // Assert sut should display error message
    XCTAssertEqual(sut.alertMessage, error.rawValue)
  }
  
  func test_loading_on_login() {
    // Given
    var loadingStatus = false
    let expect = XCTestExpectation(description: "Loading status updated")
    sut.updateLoadingStatus = { [weak sut] in
      loadingStatus = sut!.isLoading
      expect.fulfill()
    }
    
    // When fetching
    sut.attemptLogin(email: "test@test.com", password: "test12345") {
      
    }
    
    // Assert loading status true
    XCTAssertTrue(loadingStatus)
    
    // When finished login attempt
    mockAPIService!.loginSuccess()
    XCTAssertFalse(loadingStatus)
    
    wait(for: [expect], timeout: 1.0)
    
  }

  func test_login_user() {
    // Given a sut with logged in user
    goToLoginFinished()
    
    // When
    let user = sut.user
    
    // Assert non-nil
    XCTAssertNotNil(user)
  }
  
  func test_email_validation() {
    // Given a valid email
    let email = "test@test.com"
    
    // When email is validated
    sut.emailText = email
    
    // Assert email is valid
    XCTAssertTrue(sut.emailValid)
  }
  
  func test_email_validation_fail() {
    // Given an inavalid email
    let invalidEmail = "test@t"
    
    // When email is validated
    sut.emailText = invalidEmail
    
    // Assert email is invalid
    XCTAssertFalse(sut.emailValid)
    
  }
  
  func test_password_validation() {
    // Given a valid password
    let password = "test12345"
    
    // When password is validated
    sut.passwordText = password
    
    // Assert password is valid
    XCTAssertTrue(sut.passwordValid)
  }
  
  func test_password_validation_fail() {
    // Given a valid password
    let password = ""
    
    // When password is validated
    sut.passwordText = password
    
    // Assert password is valid
    XCTAssertFalse(sut.passwordValid)
  }
  
}

//MARK: State control
extension LoginViewModelTests {
  private func goToLoginFinished() {
    mockAPIService.loggedInUser = StubGenerator().stubUser()
    sut.attemptLogin(email: "test@test.com", password: "test12345") {
      
    }
    mockAPIService.loginSuccess()
  }
}

class MockAPIService: APIServiceProtocol {
  var isLoginCalled = false
  var loggedInUser: User?
  var completeClosure: ((Bool, User?, APIError?) -> ())!
  
  func login(email: String, password: String, completion: @escaping (Bool, User?, APIError?) -> ()) {
    isLoginCalled = true
    completeClosure = completion
  }
  
  func loginSuccess() {
    loggedInUser = User(id: "9dajwq90v",
                 firstName: "Test",
                  lastName: "User",
                     email: "test@test.com")
    completeClosure(true, loggedInUser, nil)
  }
  
  func loginFail(error: APIError?) {
    completeClosure(false, nil, error)
  }
}

class StubGenerator {
  func stubUser() -> User {
    let path = Bundle.main.path(forResource: "testUser", ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path))
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let user = try! decoder.decode(User.self, from: data)
    return user
  }
}
