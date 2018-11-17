//
//  ViewController.swift
//  Chat Application
//
//  Created by Prashant G on 11/15/18.
//  Copyright © 2018 MyOrg. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

//    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ref = Database.database().reference()
//        
//        self.ref.child("users").child("01").setValue(["username": "Prashant Gaikwad"])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
    }

    @objc func handleLogout() {
        let vc = LoginViewController()
        present(vc, animated: true, completion: nil)
    }

}

