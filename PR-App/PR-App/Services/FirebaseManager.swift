//
//  FirebaseManager.swift
//  PR-App
//
//  Created by Jakub Homik on 10/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import Firebase

final class FirebaseManager {
    
    func signInUser(email: String, password: String, completion: ((Result<Void, Error>) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion?(.failure(error))
            } else {
                completion?(.success(()))
            }
        }
    }
    
    func createUser(email: String, password: String, confirmPassword: String, completion: ((Result<Void, Error>) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion?(.failure(error))
            } else {
                completion?(.success(()))
//                self.showAlert(message: "Check your email with activation link!", completion: nil)
            }
            print("User created successfully")
        }
    }
}
