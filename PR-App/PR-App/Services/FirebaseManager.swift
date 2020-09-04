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
    
    private let refDatabase = Database.database().reference()
    private let refStorage = Storage.storage().reference()
    private let auth = Auth.auth()
    private let imageName = UUID().uuidString
    private let userDefaults = UserDefaults.standard
    
    // MARK: Download Medication from Firebase DB
    
    func downloadMedicationInfo(completion: @escaping([UserMedicationDetailModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        refDatabase.child(Constants.users).child(uid).child(Constants.medicationData).observeSingleEvent(of: .value) { snapshot in
            let models = snapshot.children.compactMap { child -> UserMedicationDetailModel? in
                guard let child = child as? DataSnapshot, let dict = child.value as? [String: AnyObject] else {
                    return nil
                }
                return UserMedicationDetailModel(id: child.key, dictionary: dict)
            }
            completion(models)
        }
    }
    
    // MARK: Update medication data in Firebase DB
    
    func updateMedicationInfo(pillName: String?, capacity: String?, dose: String?, cellImageURL: String?, childId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: AnyObject] = [:]
        
        if let pillName = pillName {
            values["pillName"] = pillName as AnyObject
        }
        if let capacity = capacity {
            values["capacity"] = capacity as AnyObject
        }
        if let dose = dose {
            values["dose"] = dose as AnyObject
        }
        if let cellImage = cellImageURL {
            values["cellImage"] = cellImage as AnyObject
        }
        
        refDatabase.child(Constants.users).child(uid).child(Constants.medicationData).child(childId).updateChildValues(values)
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
    
    func removeDataFromFirebase(model: UserMedicationDetailModel) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        refDatabase.child(Constants.users).child(uid).child(Constants.medicationData).child(model.id).removeValue { (error, data) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(data)
            }
        }

        let url = model.cellImage
        let storageRef = FirebaseStorage.Storage.storage().reference(forURL: url)
        storageRef.delete { (error) in
            if let error = error {
                print("image not deleted:" + error.localizedDescription)
            } else {
                print("File successfully deleted!")
            }
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
    
    func saveUserMedicationDetail(pillName: String?, capacity: String?, dose: String?, cellImage: String?) -> UserMedicationDetailModel? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        
        var values: [String: AnyObject] = [:]
        
        if let pillName = pillName {
            values["pillName"] = pillName as AnyObject
        }
        if let capacity = capacity {
            values["capacity"] = capacity as AnyObject
        }
        if let dose = dose {
            values["dose"] = dose as AnyObject
        }
        if let cellImage = cellImage {
            values["cellImage"] = cellImage as AnyObject
        }
        
        let child = refDatabase.child(Constants.users).child(uid).child(Constants.medicationData).childByAutoId()
        
        child.setValue(values)
        
        return UserMedicationDetailModel(id: child.key ?? "", dictionary: values)
    }
    
    // MARK: Observing Username
    
    func setUserName(completion: @escaping(Result<String, Error>) -> Void) {
        guard let uid = auth.currentUser?.uid else { return }
        
        refDatabase.child(Constants.users).child(uid).child(Constants.user).child(Constants.username).observeSingleEvent(of: .value) {
            snapshot in
            guard let username = snapshot.value as? String else {
                completion(.failure(NSError(domain: "UserName not received", code: 0)))
                return
            }
            completion(.success(username))
        }
    }
    
    // MARK: Reset password
    
    func resetUserPassword(with email: String, completion: @escaping(Result<Void, Error>) -> Void) {
        auth.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: Sing in user
    
    func signInUser(email: String, password: String, completion: ((Result<Bool, Error>) -> Void)?) {
        auth.signIn(withEmail: email, password: password) { (_, error) in
            guard let user = self.auth.currentUser else { return }
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
        auth.createUser(withEmail: email, password: password) { (data, error) in
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
                self.refDatabase.child(Constants.users).child(uid).child(Constants.user).setValue(values) { (error, data) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    print("User created successfully with: \(data)")
                }
            }
        }
    }
}

