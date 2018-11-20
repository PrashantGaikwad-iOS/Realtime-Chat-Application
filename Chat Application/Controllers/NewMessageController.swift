//
//  NewMessageTableViewController.swift
//  Chat Application
//
//  Created by Prashant G on 11/18/18.
//  Copyright © 2018 MyOrg. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let cellId = "cellId"
    
    var users = [User]()
    
    var ref: DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUsers()
    
    }

    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func fetchUsers() {
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                
                let user = User()
                
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.users.append(user)
                
                // this will crash bcoz of background thread so use dispatch async to fix
                self.tableView.reloadData()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        return cell
    }
}

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "Prashant")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 24
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        // ios 9 constraints anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
