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
    
    private var ref = Database.database().reference()
    
    func savingUserNameData(pillName: String, capacity: String, dose: String, completion: @escaping(Result<String, Error>) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values: Dictionary = ["pillName": pillName, "capacity": capacity, "dose": dose]
    
        ref.child("users").child(uid).child("data").updateChildValues(values) { (error, data) in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            completion(.success("\(data)"))
            print("Data saved: \(data)")
        }
    }
    
    func observeUserName(for userId: String, completion: @escaping(Result<String, Error>) -> Void) {
        
        ref.child("users").child(userId).child("username").observeSingleEvent(of: .value) {
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
                self.ref.child("users").child(uid).updateChildValues(values) { (error, data) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    print("User created successfully with: \(data)")
                }
            }
        }
    }
}
