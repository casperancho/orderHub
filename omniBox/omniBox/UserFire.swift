//
//  UserFire.swift
//  omniBox
//
//  Created by Артем Закиров on 04.12.2018.
//  Copyright © 2018 bmstu. All rights reserved.
//

import Foundation
import RealmSwift

class UserFire: Object {
    @objc dynamic var name : String? = nil
    var age = RealmOptional<Int>()
    
}

//extension UserFire{
//    func writeToRealm(){
//        try! uiRealm.write {
//            uiRealm.add(self)
//        }
//    }
//}
