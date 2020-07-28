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
    
    func observeUserName(for userId: String, completion: @escaping(Result<String, Error>) -> Void) {
        
         Database.database().reference().child("users").child(userId).child("username").observeSingleEvent(of: .value) {
             snapshot in
             guard let username = snapshot.value as? String else {
                completion(.failure(NSError(domain: "UserName not received", code: 0)))
                return }
            completion(.success(username))
        }
    }
    
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
    
    func createUser(username: String, email: String, password: String, confirmPassword: String, completion: ((Result<Void, Error>) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion?(.failure(error))
            } else {
                completion?(.success(()))
                
                guard let uid = data?.user.uid else { return }
                
                let values = ["username": username, "email": email]
                Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, data) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    print("User created successfully with: \(data)")
                }
            }
        }
    }
}
