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

protocol FirebaseManagerEvents: AnyObject {
    func saveUserMedicationDetail(cellImage: String?, medicationDetail: UserMedicationDetailModel?, completion: @escaping ((UserMedicationDetailModel) -> Void))
    func downloadMedicationInfo(completion: @escaping([UserMedicationDetailModel]) -> Void)
    func updateMedicationInfo(cellImage: String?, medicationDetail: UserMedicationDetailModel?)
    func saveImageToStorage(cellImage: Data?, completion: @escaping(Result<String, Error>) -> Void)
    func removeDataFromFirebase(model: UserMedicationDetailModel)
    func removeImageFromStorage(cellImage: String)
    func downloadImage(with urlString: String, completion: @escaping(UIImage?) -> Void)
    func setUserName(completion: @escaping(Result<String, Error>) -> Void)
    func resetUserPassword(with email: String, completion: @escaping(Result<Void, Error>) -> Void)
    func signInUser(userModel: UserModel, completion: ((Result<Bool, Error>) -> Void)?)
    func createUser(userModel: UserModel, completion: ((Result<Void, Error>) -> Void)?)
    func updateLeftCapacity(medicationID: String, leftCapacity: String?)
}

final class FirebaseManager: FirebaseManagerEvents {
    
    private let refDatabase = Database.database().reference()
    private let refStorage = Storage.storage().reference()
    private let auth = Auth.auth()
    private let imageName = UUID().uuidString
    private let cache = NSCache<NSString, UIImage>()
    
    // MARK: Download Medication from Firebase DB
    
    func downloadMedicationInfo(completion: @escaping([UserMedicationDetailModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        refDatabase.child(Constants.users).child(uid).child(Constants.medicationData).observe(.value) { snapshot in
            let models = snapshot.children.compactMap { child -> UserMedicationDetailModel? in
                guard let child = child as? DataSnapshot, let dict = child.value as? [String: AnyObject] else {
                    return nil
                }
                return UserMedicationDetailModel(userIdentifier: child.key, dictionary: dict)
            }
            completion(models)
        }
    }
    
    // MARK: Update medication data in Firebase DB
    
    func updateMedicationInfo(cellImage: String?, medicationDetail: UserMedicationDetailModel?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: AnyObject] = [:]
        
        if let pillName = medicationDetail?.pillName {
            values["pillName"] = pillName as AnyObject
        }
        if let capacity = medicationDetail?.capacity {
            values["capacity"] = capacity as AnyObject
        }
        if let dose = medicationDetail?.dose {
            values["dose"] = dose as AnyObject
        }
        if let cellImage = cellImage {
            values["cellImage"] = cellImage as AnyObject
        }
        if let frequency = medicationDetail?.frequency {
            values["frequency"] = frequency as AnyObject
        }
        if let howManyTimesPerDay = medicationDetail?.howManyTimesPerDay {
            values["howManyTimesPerDay"] = howManyTimesPerDay as AnyObject
        }
        if let whatTimeOnceRow = medicationDetail?.whatTimeOnceRow {
            values["whatTimeOnceRow"] = whatTimeOnceRow as AnyObject
        }
        if let whatTimeTwiceRow = medicationDetail?.whatTimeTwiceRow {
            values["whatTimeTwiceRow"] = whatTimeTwiceRow as AnyObject
        }
        if let whatTimeThreeRow = medicationDetail?.whatTimeThreeRow {
            values["whatTimeThreeRow"] = whatTimeThreeRow as AnyObject
        }
        if let dosage = medicationDetail?.dosage {
            values["dosage"] = dosage as AnyObject
        }
        if let leftCapacity = medicationDetail?.leftCapacity {
            values["leftCapacity"] = leftCapacity as AnyObject
        }
        
        refDatabase.child(Constants.users).child(uid).child(Constants.medicationData).child(medicationDetail?.userIdentifier ?? "").updateChildValues(values)
    }
    
    func updateLeftCapacity(medicationID: String, leftCapacity: String?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: AnyObject] = [:]
        
        if let leftCapacity = leftCapacity {
            values["leftCapacity"] = leftCapacity as AnyObject
        }
        
        refDatabase.child(Constants.users).child(uid).child(Constants.medicationData).child(medicationID).updateChildValues(values)
    }
    
    // MARK: Saving and downloading image
    
    func saveImageToStorage(cellImage: Data?, completion: @escaping(Result<String, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid, let data = cellImage else { return }
        
        if !data.isEmpty {
            refStorage.child(uid).child(imageName).putData(data, metadata: nil) { (_, error) in
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
        } else {
            print("no image to save")
        }
    }
    
    // MARK: Removing Medication from Firebase DB
    
    func removeDataFromFirebase(model: UserMedicationDetailModel) {
        guard let uid = Auth.auth().currentUser?.uid, let userIdentifier = model.userIdentifier else { return }
        refDatabase.child(Constants.users).child(uid).child(Constants.medicationData).child(userIdentifier).removeValue { (error, data) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(data)
            }
        }
        
        guard let url = model.cellImage else { return }
        let storageRef = FirebaseStorage.Storage.storage().reference(forURL: url)
        storageRef.delete { (error) in
            if let error = error {
                print("image not deleted:" + error.localizedDescription)
            } else {
                print("File successfully deleted!")
            }
        }
    }
    
    // MARK: Removing Image from Firebase Storage
    
    func removeImageFromStorage(cellImage: String) {
        let storageRef = FirebaseStorage.Storage.storage().reference(forURL: cellImage)
        storageRef.delete { (error) in
            if let error = error {
                print("image not deleted:" + error.localizedDescription)
            } else {
                print("File successfully deleted!")
            }
        }
    }
    
    // MARK: Downloading image from Firebase
    func downloadImage(with urlString: String, completion: @escaping(UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            print("got this from CACHE")
        } else {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, let image = UIImage(data: data), let response = response as? HTTPURLResponse, response.statusCode == 200, error == nil else { return }
                
                self.cache.setObject(image, forKey: cacheKey)
                completion(image)
                print("got this from firebase")
            }
            task.resume()
            print("no image to download")
        }
    }
    
    // MARK: Saving Medication to Firebase DB
    
    func saveUserMedicationDetail(cellImage: String?, medicationDetail: UserMedicationDetailModel?, completion: @escaping (UserMedicationDetailModel) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: AnyObject] = [:]
        
        if let pillName = medicationDetail?.pillName {
            values["pillName"] = pillName as AnyObject
        }
        if let capacity = medicationDetail?.capacity {
            values["capacity"] = capacity as AnyObject
        }
        if let dose = medicationDetail?.dose {
            values["dose"] = dose as AnyObject
        }
        if let cellImage = cellImage {
            values["cellImage"] = cellImage as AnyObject
        }
        if let frequency = medicationDetail?.frequency {
            values["frequency"] = frequency as AnyObject
        }
        if let howManyTimesPerDay = medicationDetail?.howManyTimesPerDay {
            values["howManyTimesPerDay"] = howManyTimesPerDay as AnyObject
        }
        if let whatTimeOnceRow = medicationDetail?.whatTimeOnceRow {
            values["whatTimeOnceRow"] = whatTimeOnceRow as AnyObject
        }
        if let whatTimeTwiceRow = medicationDetail?.whatTimeTwiceRow {
            values["whatTimeTwiceRow"] = whatTimeTwiceRow as AnyObject
        }
        if let whatTimeThreeRow = medicationDetail?.whatTimeThreeRow {
            values["whatTimeThreeRow"] = whatTimeThreeRow as AnyObject
        }
        if let dosage = medicationDetail?.dosage {
            values["dosage"] = dosage as AnyObject
        }
        
        if let leftCapacity = medicationDetail?.leftCapacity {
            values["leftCapacity"] = leftCapacity as AnyObject
        }
        
        let child = refDatabase.child(Constants.users).child(uid).child(Constants.medicationData).childByAutoId()
    
        child.setValue(values)
        
        let model = UserMedicationDetailModel(userIdentifier: child.key ?? "", dictionary: values)
        
        completion(model)
    }
    
    // MARK: Observing Username
    
    func setUserName(completion: @escaping(Result<String, Error>) -> Void) {
        guard let uid = auth.currentUser?.uid else { return }
        
        refDatabase.child(Constants.users).child(uid).child(Constants.user).child(Constants.username).observeSingleEvent(of: .value) { snapshot in
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
    
    func signInUser(userModel: UserModel, completion: ((Result<Bool, Error>) -> Void)?) {
        auth.signIn(withEmail: userModel.email, password: userModel.password) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                completion?(.failure(error))
            } else {
                guard let user = self.auth.currentUser else { return }
                completion?(.success((user.isEmailVerified)))
            }
        }
    }
    
    // MARK: Creating new user
    
    func createUser(userModel: UserModel, completion: ((Result<Void, Error>) -> Void)?) {
        auth.createUser(withEmail: userModel.email, password: userModel.password) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion?(.failure(error))
            } else {
                guard let user = Auth.auth().currentUser else { return }
                user.sendEmailVerification { (error) in
                    guard let error = error else { return }
                    print(error.localizedDescription)
                }
                completion?(.success(()))
                
                guard let uid = data?.user.uid else { return }
                
                let values = ["username": userModel.userName, "email": userModel.email]
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
