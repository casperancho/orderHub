//
//  ViewController.swift
//  omniBox
//
//  Created by Артем Закиров on 22.11.2018.
//  Copyright © 2018 bmstu. All rights reserved.
//

import UIKit
import RealmSwift

import FirebaseDatabase


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
  
    
    var full = false
    @IBOutlet weak var oldLabel: UILabel!
    @IBOutlet weak var oldSwitch: UISwitch!
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBAction func segControl(_ sender: Any) {
        full = !full
        if full{
            getAllOrders()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }else{
           getOrders()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let realm = try! Realm()
    var user = User()
    var orders = [Order]()
    let cellName = "orderCell"
    let seguename = "toOrder"
    
    lazy var refresh : UIRefreshControl = {  //сделал для обновления данных после добавления
        var refresh = UIRefreshControl()
           refresh.addTarget(self, action: #selector(ViewController.refreshData(_:)), for: .valueChanged)
        refresh.tintColor = UIColor.red
        return refresh
    }()
    

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(realm.configuration.fileURL!)
        print("user is \(user.user_id)")
        getOrders()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        self.tableView.addSubview(refresh)
        if user.user_id == "user"{
            let vc = LoginViewController()
            self.present(vc,animated: true, completion: nil)
        }
//        self.oldSwitch.setOn(false, animated: true)
//        oldLabel.text = "Выкупленные заказы"
//        self.oldSwitch.addTarget(self, action: #selector(changing(switch:)), for: .valueChanged)
        
        workFire()
        self.navigationItem.title = user.user_id
        // Do any additional setup after loading the view, typically from a nib.
    }

    @objc private func refreshData(_ refreshControl: UIRefreshControl){
        getOrders()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !(user.isAdmin){
            self.navigationItem.rightBarButtonItems = []
        }
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        // Show the Navigation Bar
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func exitButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func getAllOrders(){
        let zakazy = realm.objects(Order.self)
        orders = Array(zakazy)

    }
    
    func getOrders(){
        let zakazy = realm.objects(Order.self).filter("is_sold == false")
        orders = Array(zakazy)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? OrderCell else
        {
            return UITableViewCell()
        }
        cell.configureView(order: orders[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = orders[indexPath.row]
        performSegue(withIdentifier: seguename, sender: item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == seguename{
            guard
                let vc = segue.destination as? DisplayOrderViewController,
                let item = sender as? Order
                else{
                    return
            }
            vc.order = item
        }
    }

     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//здесь меняется статус заказа
        let row = indexPath.row
        let _ = orders[row]//let editingRow =
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("orders").child(self.orders[row].number).updateChildValues(["sold": !(self.orders[row].is_sold)])

        var vikup_title = ""
        if self.orders[row].is_sold {
            vikup_title = "Не Выкуплен"
        }else{
            vikup_title = "Выкуплен"
        }
        
        let deleteAction = UITableViewRowAction(style: .normal , title: vikup_title) { _,_ in
            try! self.realm.write {
            self.orders[row].is_sold = !(self.orders[row].is_sold)
//                self.oldSwitch.setOn(false, animated: true)
                DispatchQueue.main.async {
                    self.getOrders()
                    tableView.reloadData()
                }
            }

        }
        return [deleteAction]
    }
    
    @objc func changing(switch : UISwitch){
        if self.oldSwitch.isOn {
            DispatchQueue.main.async {
                self.getAllOrders()
                self.tableView.reloadData()
            }
        }else{
            DispatchQueue.main.async {
                self.getOrders()
                
                self.tableView.reloadData()
            }
        }
    }
    
    func workFire()  //прогружает данные из FIREBASE в REALM
    {
        let databaseref = Database.database().reference()
        databaseref.child("orders").observeSingleEvent(of: .value, with: {
            snapshot in
//            print(snapshot)
            for snap in snapshot.children.allObjects as! [DataSnapshot]{
                guard let dictionary = snap.value as? [String : AnyObject] else {
                    return
                }
                let name = dictionary["FIO"] as? String
                let number = dictionary["number"] as? String
                let arr = dictionary["arrive_date"] as? String
                let date_to = dictionary["date_to"] as? String
                let phone = dictionary["phone_number"] as? String
                let is_sold = dictionary["sold"] as? Bool
                var items_from = dictionary ["items"] as? [String : AnyObject]
                let call_status = dictionary["call_status"] as? Bool
                let comments = dictionary["comments"] as? String
//                print(items_from)
                
                var special_arr = [Item]()
                for values in (items_from!.values){
                    let whos = Item()
                    whos.item_name = (values["article"] as? String)!
                    whos.size = (values["size"] as? String)!
                    special_arr.append(whos)
                }
                
                let cur = Order()
                cur.items.append(objectsIn: special_arr)
                cur.date_to = date_to!
                cur.fio = name!
                cur.number = number!
                cur.phone_number = phone!
                cur.arr_date = arr!
                cur.is_sold = is_sold!
                cur.call_status = call_status!
                cur.comments = comments!
                try! self.realm.write {
                    self.realm.add(cur, update: true)
                }

            }
        })
    }
    
}

