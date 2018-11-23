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
    
    func fetchUserAndSetNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        ref = Database.database().reference()
        
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            let user = User()
            user.name = value!["name"] as? String
            user.email = value!["email"] as? String
            user.profileImageUrl = value!["profileImageUrl"] as? String
            self.setupNavBarWithWithUser(user: user)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func setupNavBarWithWithUser(user:User) {

        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        // titleView.backgroundColor = .red
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor,constant:8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = containerView
    }
    
    fileprivate func checkIfUserIsLoggedIn() {
        // user is not logged in
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else{
            fetchUserAndSetNavBarTitle()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ref = Database.database().reference()
//        self.ref.child("users").child("01").setValue(["username": "Prashant Gaikwad"])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "startNewChat")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image , style: .plain, target: self, action: #selector(handleNewMsg))
        
        checkIfUserIsLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        vc.messagesVC = self
        present(vc, animated: true, completion: nil)
    }

}

