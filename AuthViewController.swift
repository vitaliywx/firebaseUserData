//
//  AuthViewController.swift
//  FireBaseUserData
//
//  Created by Vitalii Homoniuk on 22.12.2022.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {
        
    var signup: Bool = true {
        willSet {
            if newValue {
//                warningLabel.isHidden = true
                titleLabel.text = "Registration"
                nameTextField.isHidden = false
                enterButton.setTitle("Sign up", for: .normal)
                switchButton.setTitle("Already have an account?", for: .normal)
            } else {
//                warningLabel.isHidden = true
                titleLabel.text = "Authorization"
                nameTextField.isHidden = true
                enterButton.setTitle("Log in", for: .normal)
                switchButton.setTitle("Don't have an account?", for: .normal)
            }
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func switchButtonAction(_ sender: Any) {
        signup = !signup
    }
    
    @IBAction func enterButtonAction(_ sender: Any) {
        let name = nameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        APIManager.shared.enter(name: name, email: email, password: password, isSignup: signup, target: self) {
            self.warningLabel.isHidden = false
        }
    }
    
    
}
