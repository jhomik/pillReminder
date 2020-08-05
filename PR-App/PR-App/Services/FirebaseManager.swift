//
//  FirebaseManager.swift
//  PR-App
//
//  Created by Jakub Homik on 10/07/2020.
//  Copyright © 2020 Jakub Homik. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

final class FirebaseManager {
    
    private var refDatabase = Database.database().reference()
    private var refStorage = Storage.storage().reference()
    private let users = "users"
    private let username = "username"
    private let medicationData = "medicationData"
    private let user = "user"
    
    // MARK: Observing Medication in Firebase DB
    
    func observeMedicationInfo(completion: @escaping(Result<UserMedicationDetailModel, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        refDatabase.child(users).child(uid).child(medicationData).observe(.value) { (snapshot) in
            guard let medicationInfo = snapshot.value as? [String : AnyObject] else {
                completion(.failure(NSError(domain: "Data not received", code: 0)))
                return
            }
            let data = UserMedicationDetailModel(dictionary: medicationInfo)
            completion(.success(data))
        }
    }
    
    //    func savingMedicationInfoCell(image: String, title: String, completion: @escaping (Result<String, Error>) -> Void) {
    //        guard let uid = Auth.auth().currentUser?.uid else { return }
    //
    ////        ref.child(users).child(uid).child(medication).child(data).chil
    //    }
    
    // MARK: Saving Medication to Firebase DB
    
    func savingImageToStorage(cellImage: Data, completion: @escaping(Result<String, Error>) -> Void) {
        refStorage.child("images/file.png").putData(cellImage, metadata: nil) { (_, error) in
            guard error == nil else {
                completion(.failure(NSError(domain: "Saving image to storage failed", code: 0)))
                return
            }

            self.refStorage.child("images/file.png").downloadURL { (url, error) in
                guard let url = url, error == nil else { return }
                let urlString = url.absoluteString
                completion(.success(urlString))
                print("URL downloaded: \(urlString)")
            }
        }
    }
    
    func savingUserMedicationDetail(pillName: String?, capacity: String?, dose: String?, cellImage: String?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: String] = [:]
        
        if let pillName = pillName {
            values["pillName"] = pillName
        }
        if let capacity = capacity {
            values["capacity"] = capacity
        }
        if let dose = dose {
            values["dose"] = dose
        }
        if let cellImage = cellImage {
            values["cellImage"] = cellImage
        }
        
        refDatabase.child(users).child(uid).child(medicationData).updateChildValues(values) { (error, data) in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            completion(.success("\(data)"))
            print("Data saved: \(data)")
        }
    }
    
    // MARK: Observing Username
    
    func observeUserName(completion: @escaping(Result<String, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        refDatabase.child(users).child(uid).child(user).child(username).observeSingleEvent(of: .value) {
            snapshot in
            guard let username = snapshot.value as? String else {
                completion(.failure(NSError(domain: "UserName not received", code: 0)))
                return
            }
            completion(.success(username))
        }
    }
    
    // MARK: Sing in user
    
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
    
    // MARK: Creating new user
    
    func createUser(username: String, email: String, password: String, confirmPassword: String, completion: ((Result<Void, Error>) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion?(.failure(error))
            } else {
                completion?(.success(()))
                
                guard let uid = data?.user.uid else { return }
                
                let values = ["username": username, "email": email]
                self.refDatabase.child(self.users).child(uid).child(self.user).updateChildValues(values) { (error, data) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    print("User created successfully with: \(data)")
                }
            }
        }
    }
}
