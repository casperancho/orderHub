//
//  LoginViewController.swift
//  omniBox
//
//  Created by Артем Закиров on 26.11.2018.
//  Copyright © 2018 bmstu. All rights reserved.
//

import Foundation
import UIKit

import RealmSwift
import FirebaseDatabase

class LoginViewController : UIViewController{
    
    @IBOutlet weak var segmentedCon: UISegmentedControl!
    private let seguename = "zakzak"
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func loginButton(_ sender: Any) {
        //checkRegistrated()
    }
    @IBAction func signButton(_ sender: UIButton) {
        
        if isSignIn {
            if checkRegistrated() {
                print("norm")
                performSegue(withIdentifier: seguename, sender: UIButton.self)
            }else{
            print("new user")
                //signButton.setImage(_ image: UIImage("regButton"), for: UIControl.State.Normal)
                
            }
        }
    }
    let realm = try! Realm()
    var isSignIn : Bool = true
    
    @IBOutlet weak var signButton: UIButton!
    
    
    @IBAction func selectorChanged(_ sender: UISegmentedControl) {
        
        isSignIn = !isSignIn
        
        if isSignIn {
            signButton.setTitle("", for: .normal)
            signButton.setImage(UIImage(named: "enterButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }else{
            signButton.setTitle("", for: .normal)
            signButton.setImage(UIImage(named: "regButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
    }
    
    func checkRegistrated() -> Bool{
        let login = loginField.text!
        let checkingPerson = realm.objects(User.self)   //заходим  в базу
        let filtered = checkingPerson.filter("user_id == %@",login).first //фильтруем и ищем по нужным параметрам
        if filtered != nil {
            let pass = filtered!.password 
            if (pass == passwordField.text!){
                print("Excellent!")
                return true
            } else {
                print(pass)
                print("POWEL HA XYU! parol")
                callAlert()
                passwordField.text = ""
                return false
            }
        } else {
            print("POWEL HA XYU! persona")
            callAlert()
            loginField.text = ""
            passwordField.text = ""
            return false
        }
    }


func callAlert(){
    let alertView = UIAlertController(title: "Ошибка", message: "Проверьте введенные данные", preferredStyle: .alert)
    
    let add = UIAlertAction(title: "Ок", style: .destructive) { (action) in
    }
   alertView.addAction(add)
    self.present(alertView, animated: true, completion: nil)
}

    
    override func viewWillAppear(_ animated: Bool) {

//        self.loginField.text = ""
//        self.passwordField.text = ""
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == seguename{
            guard
            let vc = segue.destination as? ViewController
                else {return}
            let realm = try! Realm()
            let login = loginField.text!
            let checkingPerson = realm.objects(User.self)   //заходим  в базу
            let filtered = checkingPerson.filter("user_id == %@",login).first
            if filtered != nil {
                vc.user = filtered!}
        }
    }
    
    func downloadFromFire()
    {
        let databaseref = Database.database().reference()
        databaseref.child("users").observeSingleEvent(of: .value, with: {
            snapshot in
            for snap in snapshot.children.allObjects as! [DataSnapshot]{
                guard let dictionary = snap.value as? [String : AnyObject] else {
                    return
                }
                let user_id = dictionary["user_id"] as? String
                let password = dictionary["password"] as? String
                let isAdmin = dictionary["isAdmin"] as? Bool

                let newUser = User()
                newUser.user_id = user_id!
                newUser.password = password!
                newUser.isAdmin = isAdmin!

                try! self.realm.write {
                    self.realm.add(newUser, update: true)
                }

            }
        })
    }
    
    
    
    
    override func viewDidLoad() {
        downloadFromFire()
    }
    
}
