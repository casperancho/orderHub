//
//  Item.swift
//  omniBox
//
//  Created by Артем Закиров on 22.11.2018.
//  Copyright © 2018 bmstu. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var item_name : String = ""
    @objc dynamic var desc : String = ""
    @objc dynamic var price : String  = ""
    @objc dynamic var photo_url : String  = ""
    @objc dynamic var size : String = ""
    
}
