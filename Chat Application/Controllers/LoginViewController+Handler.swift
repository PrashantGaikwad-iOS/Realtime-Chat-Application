//
//  LoginViewController+Handler.swift
//  Chat Application
//
//  Created by Prashant G on 11/20/18.
//  Copyright © 2018 MyOrg. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @objc func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = authResult?.user.uid else {
                return
            }
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profileImages/\(imageName).png")
            if let uploadData = self.profileImageView.image!.pngData() {
                storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                    
                    guard let metadata = metaData else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    print(metadata)
                    if error != nil {
                        print(error!)
                        return
                    }
                    // You can also access to download URL after upload.
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            return
                        }
                        let values = ["name":name, "email":email, "profileImageUrl":downloadURL.absoluteString] as [String : Any]
                        self.registerUserInDatabaseWithUID(uid,values: values as [String : AnyObject])
                    }
                }
            }
        }
    }
    
    fileprivate func registerUserInDatabaseWithUID(_ uid: String, values:[String:AnyObject]) {
        var ref: DatabaseReference!
        ref = Database.database().reference(fromURL: "https://letsconnect-ad375.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
            print("successfully saved the user into Firebase db")
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cenceled picker")
        self.dismiss(animated: true, completion: nil)
    }
}




//            guard let user = authResult?.user else { return }

//            ref.child("users").child(user.uid).setValue(["name": name, "email": email]) {
//                (error:Error?, ref:DatabaseReference) in
//                if let error = error {
//                    print("Data could not be saved: \(error).")
//                } else {
//                    print("Data saved successfully!")
//                }
//            }
