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
    private let imageName = UUID().uuidString
    private let userDefaults = UserDefaults.standard
    
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
    
    func saveImageToStorage(cellImage: Data, completion: @escaping(Result<String, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        refStorage.child(uid).child(imageName).putData(cellImage, metadata: nil) { (_, error) in
            guard error == nil else {
                completion(.failure(NSError(domain: "Saving image to storage failed", code: 0)))
                return
            }
            
            self.refStorage.child(uid).child(self.imageName).downloadURL { (url, error) in
                guard let url = url, error == nil else { return }
                let urlString = url.absoluteString
                completion(.success(urlString))
                print("URL downloaded: \(urlString)")
            }
        }
    }
    
    //MARK: Removing Medication from Firebase DB
    
    func removeData(from cell: CustomCell) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if let medicationID = refDatabase.child(medicationData).key {
            refDatabase.child(users).child(uid).child(medicationData).child(medicationID).removeValue()
            print(medicationID)
        }
    }
    
    // MARK: Downloading image or retrive from UserDefaults Data
    
    func downloadImage(with urlString: String, imageCell: UIImageView) {
        
        if let data = self.userDefaults.data(forKey: urlString), let image = UIImage(data: data) {
            imageCell.image = image
            print("got this image from UserDefaults")
            print(userDefaults)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self?.userDefaults.set(image.jpegData(compressionQuality: 0), forKey: urlString)
                    imageCell.image = image
                    print("got this from firebase")
                }
            }
        }
        task.resume()
    }
    
    // MARK: Saving Medication to Firebase DB

    func saveUserMedicationDetail(pillName: String?, capacity: String?, dose: String?, cellImage: String?) {
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
    
    // MARK: Reset password
    
    // MARK: Sing in user
    
    func signInUser(email: String, password: String, completion: ((Result<Bool, Error>) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            guard let user = Auth.auth().currentUser else { return }
            if let error = error {
                print(error.localizedDescription)
                completion?(.failure(error))
            } else {
                completion?(.success((user.isEmailVerified)))
            }
        }
    }
    
    // MARK: Creating new user
    
    func createUser(username: String, email: String, password: String, confirmPassword: String, completion: ((Result<Void, Error>) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            guard let user = Auth.auth().currentUser else { return }
            
            if let error = error {
                print(error.localizedDescription)
                completion?(.failure(error))
            } else {
                user.sendEmailVerification { (error) in
                    guard let error = error else { return }
                    print(error.localizedDescription)
                }
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
