//
//  APIService.swift
//  JWHDemo
//
//  Created by Julian Hays on 12/5/18.
//  Copyright © 2018 orbosphere. All rights reserved.
//
// APIService provides a basic login function that simulates the response from a real API
// The hard-coded test credentials are:
// email: test@test.com
// password: test12345
//
// After a short delay, the service will will call the completion closure
// which will contain a success bool, an optional user (loaded from an embedded .json file), and an optional APIError

import Foundation

enum APIError: String, Error {
  case permissionDenied = "Permission Denied"
  case serverError = "Server Error"
}

protocol APIServiceProtocol {
  func login(email:String, password: String, completion: @escaping (_ success: Bool, _ user: User?, _ error: APIError?)->() )
}

class APIService: APIServiceProtocol {
  //simulate a short wait for login
  func login(email: String, password: String, completion: @escaping (Bool, User?, APIError?) -> ()) {
    DispatchQueue.global().async {
      sleep(2)
      let path = Bundle.main.path(forResource: "testUser", ofType: "json") ?? ""
      
      if email == "test@test.com" &&
        password == "test12345" {
        do {
          let data = try Data(contentsOf: URL(fileURLWithPath: path))
          let decoder = JSONDecoder()
          let user = try decoder.decode(User.self, from: data)
          completion(true, user, nil)
        } catch {
          completion(false, nil, APIError.serverError)
        }
      } else {
        completion(false, nil, APIError.permissionDenied)
      }
    }
  }
}
