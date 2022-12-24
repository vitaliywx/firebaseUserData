//
//  AuthViewController.swift
//  FireBaseUserData
//
//  Created by Vitalii Homoniuk on 22.12.2022.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {
        
    var isSignup: Bool = true {
        willSet {
            if newValue {
                titleLabel.text = "Registration"
                nameTextField.isHidden = false
                enterButton.setTitle("Sign up", for: .normal)
                switchButton.setTitle("Already have an account?", for: .normal)
            } else {
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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func switchButtonAction(_ sender: Any) {
        isSignup = !isSignup
    }
    
    @IBAction func enterButtonAction(_ sender: Any) {
        let name = nameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        setupSpinner(seconds: 2)
        
        if self.isSignup {
            APIManager.shared.signup(name: name, email: email, password: password, vc: self, warningLabel: warningLabel)
        } else {
            APIManager.shared.login(email: email, password: password, vc: self, warningLabel: warningLabel)
        }
    }
    
    private func setupSpinner(seconds: Int) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
            self.spinner.stopAnimating()
        }
    }
}
