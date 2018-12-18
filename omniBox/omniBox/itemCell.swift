//
//  ItemCell.swift
//  omniBox
//
//  Created by Артем Закиров on 30.11.2018.
//  Copyright © 2018 bmstu. All rights reserved.
//

import Foundation
import UIKit

class ItemCell : UITableViewCell {
    var item = Item()
    
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    func configureView(item: Item){
        self.articleLabel.text = item.item_name
        self.sizeLabel.text = item.size
    }
}
