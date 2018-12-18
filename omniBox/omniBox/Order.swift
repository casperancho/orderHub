//
//  Order.swift
//  omniBox
//
//  Created by Артем Закиров on 26.11.2018.
//  Copyright © 2018 bmstu. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Order: Object {
    @objc dynamic var number : String = ""
    @objc dynamic var fio : String = ""
    @objc dynamic var phone_number : String = ""
    @objc dynamic var arr_date : String = ""
    @objc dynamic var date_to : String = ""
    var items = List<Item>()
    @objc dynamic var is_sold : Bool = false
    @objc dynamic var comments : String = ""
    @objc dynamic var call_status : Bool = false
   
    override static func primaryKey() -> String?{
        return "number"
    }
}
