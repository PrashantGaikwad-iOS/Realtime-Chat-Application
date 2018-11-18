//
//  ViewController.swift
//  Chat Application
//
//  Created by Prashant G on 11/15/18.
//  Copyright © 2018 MyOrg. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

    var ref: DatabaseReference!
    
    fileprivate func extractedFunc() {
        // user is not logged in
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else{
            let uid = Auth.auth().currentUser?.uid
            ref = Database.database().reference()
            
            ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""

                self.navigationItem.title = name
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ref = Database.database().reference()
//        self.ref.child("users").child("01").setValue(["username": "Prashant Gaikwad"])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "startNewChat")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image , style: .plain, target: self, action: #selector(handleNewMsg))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        extractedFunc()
    }
    
    @objc func handleNewMsg() {
        let vc = NewMessageController()
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true, completion: nil)
    }

    @objc func handleLogout() {
        
        do{
            try Auth.auth().signOut()
        }catch let logOutError{
            print(logOutError)
        }
        
        let vc = LoginViewController()
        present(vc, animated: true, completion: nil)
    }

}

