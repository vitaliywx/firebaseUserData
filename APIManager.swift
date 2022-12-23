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
    
    func enter(name: String, email: String, password: String, isSignup: Bool, target: UIViewController, completion: @escaping () -> ()) {
        
        if isSignup {
            if (!name.isEmpty && !email.isEmpty && !password.isEmpty) {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if error == nil {
                        if let result = result {
                            print(result.user.uid)
                            let ref = Database.database().reference().child("users")
                            ref.child(result.user.uid).updateChildValues(["name": name, "email": email])
                            target.dismiss(animated: true)
                        }
                    }
                }
            } else {
                completion()
            }
        } else {
            if (!email.isEmpty && !password.isEmpty) {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if error == nil {
                        target.dismiss(animated: true)
                    }
                }
            } else {
                completion()
            }
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
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref = Database.database().reference().child("users/\(uid)/tasks")
        
        let encoder = JSONEncoder()
        guard let ref = ref else { return }
        if text.isEmpty { return }
        let task = Task(text: text)
        
        do {
            let data = try encoder.encode(task)
            let json = try JSONSerialization.jsonObject(with: data)
            ref.childByAutoId().setValue(json)
        } catch {
            print("an error occurred", error)
        }
    }
    
    func getAllData(vc: HomeViewController) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref = Database.database().reference().child("users/\(uid)/tasks")
        let decoder = JSONDecoder()
        
        if let ref = ref {
            ref.observe(.childAdded) { (snapshot, arg)  in

                guard var json = snapshot.value as? [String: Any] else { return }
                json["id"] = snapshot.key

                do {
                    let data = try JSONSerialization.data(withJSONObject: json)
                    let task = try decoder.decode(Task.self, from: data)
                    vc.tasks.append(task)
                    vc.tableView.reloadData()
                } catch {
                    print("an error occurred", error)
                }
            }
        }
    }
    
    func updateData(text: String) {
        
    }
    
    func deleteData() {
        
    }
}
