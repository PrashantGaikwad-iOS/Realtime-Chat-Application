//
//  LoginViewController.swift
//  Chat Application
//
//  Created by Prashant G on 11/15/18.
//  Copyright © 2018 MyOrg. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UIGestureRecognizerDelegate {

    var messagesVC = MessagesController()
    
    let inputsContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginRegisterButton:UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let nameTextField:UITextField = {
        let nm = UITextField()
        nm.placeholder = "Name"
        nm.translatesAutoresizingMaskIntoConstraints = false
        return nm
    }()
    
    let emailTextField:UITextField = {
        let nm = UITextField()
        nm.placeholder = "Email"
        nm.translatesAutoresizingMaskIntoConstraints = false
        return nm
    }()
    
    let passwordTextField:UITextField = {
        let nm = UITextField()
        nm.placeholder = "Password"
        nm.isSecureTextEntry = true
        nm.translatesAutoresizingMaskIntoConstraints = false
        return nm
    }()
    
    lazy var profileImageView:UIImageView = {
       let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "chat")
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .clear
        img.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView))
        img.addGestureRecognizer(tap)
        return img
    }()
    
    lazy var loginRegisterSegmetedControl:UISegmentedControl = {
       let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmetedControl)
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(passwordTextField)
        
        view.addSubview(profileImageView)
        
        setupInputsContainerView()
        setupRegisterButtonView()
        setupNameTextFieldView()
        setupEmailTextFieldView()
        setupPasswordTextFieldView()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        
    }
    
    @objc func handleLoginRegisterChange() {
//        print(loginRegisterSegmetedControl.selectedSegmentIndex)
        
        let title = loginRegisterSegmetedControl.titleForSegment(at: loginRegisterSegmetedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // Change height of inputContainerView
        inputContainerViewHeightAnchor?.constant = loginRegisterSegmetedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // Change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmetedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmetedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmetedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        
    }
    
    func setupLoginRegisterSegmentedControl()  {
        loginRegisterSegmetedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmetedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmetedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmetedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmetedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }
        else{
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("form is not valid")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                print(error!)
                return
            }
            // Successfully logged in
            self.messagesVC.fetchUserAndSetNavBarTitle()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmetedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    fileprivate func setupNameTextFieldView() {
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -12).isActive = true
        nameTextFieldHeightAnchor =  nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
    }
    
    fileprivate func setupEmailTextFieldView() {
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -12).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
    }
    
    fileprivate func setupPasswordTextFieldView() {
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 12).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: inputsContainerView.trailingAnchor, constant: -12).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    fileprivate func setupRegisterButtonView() {
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    fileprivate func setupInputsContainerView() {
        // need x, y, width, height
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightAnchor?.isActive = true
    }
    
    func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
}


extension UIColor {
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat) {
        self.init(red:r/255, green:g/255, blue:b/255, alpha: 1)
    }
}
