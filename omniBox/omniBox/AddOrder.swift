//
//  AddOrder.swift
//  omniBox
//
//  Created by Артем Закиров on 26.11.2018.
//  Copyright © 2018 bmstu. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import FirebaseDatabase

class AddOrder: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var orderText: UITextField!
    @IBOutlet weak var fioText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var dataPick: UIDatePicker!

    var items = [Item]()
    @IBOutlet weak var tovarTable: UITableView!
    let cellName = "itemCell"
    @IBAction func addTovarButtob(_ sender: Any) {
        callAddAlert()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        addOrder()
        self.dismiss(animated: true, completion: nil)
    }

    func addOrder(){
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let today = dateFormatter.string(from: dataPick.date)  // from dataPicker to string date
        let realm = try! Realm()
        let new_order = Order()
        new_order.number = self.orderText.text!
        new_order.fio = self.fioText.text!
        new_order.phone_number = self.phoneText.text!
        new_order.arr_date = today
        var date_to = Calendar.current.date(byAdding: .day, value: 5, to: (dateFormatter.date(from: today))!) //add 5 day
        new_order.date_to = dateFormatter.string(from: date_to!)
        new_order.items.append(objectsIn: items)
        print(new_order)
//
        try! realm.write {
            realm.add(new_order)
        loadToFireBase(new_order: new_order)
        }
       print(realm.configuration.fileURL!)
        
    }
    
    func loadToFireBase(new_order : Order){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("orders").child(new_order.number).setValue(["number": new_order.number, "FIO": new_order.fio, "phone_number": new_order.phone_number, "arrive_date" : new_order.arr_date, "date_to" : new_order.date_to, "sold": false, "comments": "","call_status" : false]) // добавление заказа
        for val in items.enumerated(){   //добавление товаров
            ref.child("orders").child(new_order.number).child("items").child(val.element.item_name).setValue(["article": val.element.item_name, "size":val.element.size,"photo_url": ""])
        }
        
    }

    func callAddAlert(){
        let alertView = UIAlertController(title: "Добавление заказов", message: nil, preferredStyle: .alert)
        let add = UIAlertAction(title: "Добавить", style: .default) { (action) in
            let addItem = Item()
            addItem.item_name = alertView.textFields![0].text!
            addItem.size = alertView.textFields![1].text!
            self.items.append(addItem)
            DispatchQueue.main.async {
                self.tovarTable.reloadData()
            }

        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alertView.addAction(add)
        alertView.addAction(cancel)
        alertView.addTextField { (textfield) in
            textfield.placeholder = "Артикул"
        }
        alertView.addTextField { (textfield) in
            textfield.placeholder = "Размер"
        }
        self.present(alertView, animated: true, completion: {
            print("Alert worked")
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 {
            return 0
        }else{
          return items.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? ItemCell else
        {
            return UITableViewCell()
        }
        cell.configureView(item: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @IBOutlet var tapMe: UIView!
    override func viewDidLoad() {
        tovarTable.dataSource = self
        tovarTable.delegate = self
        tovarTable.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBord))
        tapGesture.numberOfTapsRequired = 1
        tapMe.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyBord(){
        self.view.endEditing(true)
    }
    
}



