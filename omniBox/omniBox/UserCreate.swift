//
//  UserCreate.swift
//  omniBox
//
//  Created by Артем Закиров on 26.11.2018.
//  Copyright © 2018 bmstu. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import FirebaseDatabase

class UserCreate : UIViewController{
    let realm = try! Realm()
    @IBAction func createButton(_ sender: Any) {
        addUser()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var loginField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    func upload(newUser : User){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(newUser.user_id).setValue(["user_id": newUser.user_id, "password": newUser.password, "isAdmin": newUser.isAdmin])
    }
    
    func addUser(){
        
        print("userTable path:\n \(String(describing: realm.configuration.fileURL))")
        let newUser = User()
        newUser.user_id = loginField.text!
        newUser.password = passwordField.text!
        newUser.isAdmin = false
    
        try! self.realm.write {
            self.realm.add(newUser)
            upload(newUser: newUser)
        }
    }
}
