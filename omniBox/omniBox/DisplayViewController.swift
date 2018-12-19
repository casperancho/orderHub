//
//  DisplayViewController.swift
//  omniBox
//
//  Created by Артем Закиров on 28.11.2018.
//  Copyright © 2018 bmstu. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import MessageUI
import FirebaseDatabase


class DisplayOrderViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate {
    

    @IBOutlet var tapMe: UIView!
    

    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var orderTable: UITableView!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var dateToLabel: UILabel!
    @IBOutlet weak var arrDateLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var fioLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    let cellName = "itemCell"
    var order = Order()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(order: self.order)
        orderTable.dataSource = self
        orderTable.delegate = self
        orderTable.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBord))
        tapGesture.numberOfTapsRequired = 1
        tapMe.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyBord(){
        self.view.endEditing(true)
    }
    
    func configure(order: Order){
        headerLabel.text = "Информация о заказе:"
        numberLabel.text = "Номер закаказа:\(order.number)"
        fioLabel.text = "Данные: \(order.fio)"
        phoneLabel.text = "Номер телефона: \(order.phone_number)"
        arrDateLabel.text = "От \(order.arr_date)"
        dateToLabel.text = "Выдать до \(order.date_to)"
        itemsLabel.text = "Товары: "
        statusLabel.text = "Статус обзвона и комментарий"
        statusSwitch.isOn = order.call_status
        commentField.text = order.comments
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if order.items.count == 0{
            return 0
        }else{
            return order.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? ItemCell else
        {
            return UITableViewCell()
        }
        cell.configureView(item: order.items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @IBAction func statusChanged(_ sender: Any) {
        try! realm.write {
            order.call_status = statusSwitch.isOn
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        if (commentField.text != order.comments) {
            try! realm.write {
                order.comments = commentField.text!
            }
            ref.child("orders").child(order.number).updateChildValues(["comments": commentField.text!])
        }else{
            ref.child("orders").child(order.number).updateChildValues(["call_status": statusSwitch.isOn])
        }
        
    }
  
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendMessage(_ sender: Any) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        composeVC.recipients = ["\(order.phone_number)"]
        composeVC.body = "Ваш заказ: \(order.number) готов. Будем рады вас видеть. Крайний срок : \(order.date_to)"
        
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
        
    }
    @IBAction func callButton(_ sender: Any) {
        print("im here")
        let phone = "TEL://\(order.phone_number)"
        print(phone)
        let url: NSURL = NSURL(string: phone)!
        UIApplication.shared.openURL(url as URL)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
