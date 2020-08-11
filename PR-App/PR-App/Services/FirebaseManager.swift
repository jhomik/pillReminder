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
    
    // MARK: Download Medication from Firebase DB
    
    func downloadMedicationInfo(completion: @escaping([UserMedicationDetailModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
            
        refDatabase.child(users).child(uid).child(medicationData).observeSingleEvent(of: .value) { snapshot in
            let models = snapshot.children.compactMap { child -> UserMedicationDetailModel? in
                guard let child = child as? DataSnapshot, let dict = child.value as? [String: AnyObject] else {
                    return nil
                }
                                                       
                return UserMedicationDetailModel(dictionary: dict)
            }
            
            completion(models)
        }
    }

    // MARK: Saving and downloading image to storage
    
    func savingImageToStorage(cellImage: Data, completion: @escaping(Result<String, Error>) -> Void) {
        refStorage.child("images/file.jpg").putData(cellImage, metadata: nil) { (_, error) in
            guard error == nil else {
                completion(.failure(NSError(domain: "Saving image to storage failed", code: 0)))
                return
            }
            
            self.refStorage.child("images/file.jpg").downloadURL { (url, error) in
                guard let url = url, error == nil else { return }
                let urlString = url.absoluteString
                completion(.success(urlString))
                print("URL downloaded: \(urlString)")
            }
        }
    }
    
    // MARK: Saving Medication to Firebase DB
    
    func savingUserMedicationDetail(pillName: String?, capacity: String?, dose: String?, cellImage: String?) {
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
        
        refDatabase.child(users).child(uid).child(medicationData).childByAutoId().setValue(values)
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
                self.refDatabase.child(self.users).child(uid).child(self.user).setValue(values) { (error, data) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    print("User created successfully with: \(data)")
                }
            }
        }
    }
}
