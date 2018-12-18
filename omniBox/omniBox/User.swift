//
//  User.swift
//  omniBox
//
//  Created by Артем Закиров on 22.11.2018.
//  Copyright © 2018 bmstu. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object{
    @objc dynamic var user_id : String = "user"
    @objc dynamic var password : String = "password"
    @objc dynamic var isAdmin : Bool = false

    override static func primaryKey() -> String?{
        return "user_id"
    }
}
