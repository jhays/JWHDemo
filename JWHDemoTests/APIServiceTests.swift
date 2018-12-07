//
//  APIServiceTests.swift
//  JWHDemoTests
//
//  Created by Julian Hays on 12/5/18.
//  Copyright © 2018 orbosphere. All rights reserved.
//

import XCTest
@testable import JWHDemo

class APIServiceTests: XCTestCase {

  var sut: APIService?

  override func setUp() {
    super.setUp()
    sut = APIService()
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func test_valid_login() {
    //Given the APIService
    guard let sut = self.sut else {
      XCTFail("sut was nil")
      return
    }
    
    //When login attempted with valid creds
    let expect = XCTestExpectation(description: "callback")
    let email = "test@test.com"
    let password = "test12345"
    
    sut.login(email: email, password: password) { (success, user, error) in
      expect.fulfill()
      XCTAssertTrue(success)
      XCTAssertNotNil(user)
      XCTAssertNil(error)
    }
    
    wait(for: [expect], timeout: 2.1)
  }
  
  func test_invalid_login() {
    //Given the APIService
    guard let sut = self.sut else {
      XCTFail("sut was nil")
      return
    }
    
    //When login attempted with invalid creds
    let expect = XCTestExpectation(description: "callback")
    let email = "invalid@test.com"
    let password = "invalid"
    
    sut.login(email: email, password: password) { (success, user, error) in
      expect.fulfill()
      XCTAssertFalse(success)
      XCTAssertNil(user)
      XCTAssertNotNil(error)
      XCTAssertEqual(error, APIError.permissionDenied)
    }
    
    wait(for: [expect], timeout: 2.1)
  }

}
