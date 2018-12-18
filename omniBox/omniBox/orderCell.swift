//
//  orderCell.swift
//  omniBox
//
//  Created by Артем Закиров on 27.11.2018.
//  Copyright © 2018 bmstu. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class OrderCell: UITableViewCell {
   
    var order = Order()
    
    @IBOutlet weak var date_toLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var fioLabel: UILabel!
    
    func configureView(order : Order){
        self.date_toLabel.text = "Выдать до \(order.date_to)"
        self.orderLabel.text = "Заказ: \(order.number)"
        self.fioLabel.text = "\(order.fio)"
        self.phoneLabel.text = "\(order.phone_number)"
        if order.is_sold {self.backgroundColor = UIColor.green} else {self.backgroundColor = UIColor.white}
    }
}
