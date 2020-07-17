//
//  FirebaseManager.swift
//  PR-App
//
//  Created by Jakub Homik on 10/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import Firebase

final class FirebaseManager: UIViewController {
    
    func signInUser(email: String, password: String, completion: ((Result<Void, Error>) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion?(.failure(error))
                // TO DO: add alert with informations //
            } else {
                completion?(.success(()))
            }
            print("User logged successfully")
        }
    }
    
    func createUser(email: String, password: String, confirmPassword: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                
                // TO DO: add alert with informations //
                
            } else {
                self.showAlert(message: "Check your email with activation link!", completion: nil)
            }
            print("User created successfully")
        }
    }
}
