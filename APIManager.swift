//
//  APIManager.swift
//  FireBaseUserData
//
//  Created by Vitalii Homoniuk on 22.12.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class APIManager {
    
    static let shared = APIManager()
    
    private var ref: DatabaseReference!
        
    func login(email: String, password: String, vc: UIViewController, warningLabel: UILabel) {
        if (!email.isEmpty && !password.isEmpty) {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if error == nil {
                    vc.dismiss(animated: true)
                } else {
                    warningLabel.text = "Wrong email or password"
                    warningLabel.isHidden = false
                }
            }
        } else {
            warningLabel.text = "Wrong email or password"
            warningLabel.isHidden = false
        }
    }
    
    func signup(name: String, email: String, password: String, vc: UIViewController, warningLabel: UILabel) {
        if (!name.isEmpty && !email.isEmpty && !password.isEmpty) {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if error == nil {
                    if let result = result {
                        print(result.user.uid)
                        let ref = Database.database().reference().child("users")
                        ref.child(result.user.uid).updateChildValues(["name": name, "email": email])
                        vc.dismiss(animated: true)
                    }
                } else {
                    warningLabel.text = "Error occurred"
                    warningLabel.isHidden = false
                }
            }
        } else {
            warningLabel.text = "Some field is empty"
            warningLabel.isHidden = false
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    func postData(text: String) {
        if let uid = Auth.auth().currentUser?.uid, var ref = ref  {
            if let taskId = ref.childByAutoId().key, !text.isEmpty {
                ref = Database.database().reference().child("users/\(uid)/tasks")
                let task = Task(text: text, taskId: taskId)
                ref.child(taskId).setValue(["taskId": taskId, "text": task.text])
            }
        }
    }
    
    func getAllData(vc: HomeViewController) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref = Database.database().reference().child("users/\(uid)/tasks")
        let decoder = JSONDecoder()
        guard let ref = ref else { return }
        
        ref.observe(.childAdded) { snapshot  in
            if let userDict = snapshot.value as? [String: Any] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: userDict)
                    let task = try decoder.decode(Task.self, from: data)
                    vc.tasks.append(task)
                    vc.tableView.reloadData()
                } catch {
                    print("an error occurred", error)
                }
            }
        }
    }
    
    func updateData(newValue: String, taskId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref = Database.database().reference().child("users/\(uid)/tasks")
        ref.child(taskId).updateChildValues(["text": newValue])
    }
    
    func deleteData(taskId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref = Database.database().reference().child("users/\(uid)/tasks")
        ref.child(taskId).removeValue()
    }
}
