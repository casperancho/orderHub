//
//  collectionViewController.swift
//  omniBox
//
//  Created by Артем Закиров on 25.12.2018.
//  Copyright © 2018 bmstu. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import AlamofireImage
import Alamofire

class CollectionViewController : UIViewController{
    
    @IBOutlet weak var clView: UICollectionView!
    
    var realm = try! Realm()
    var menuArr = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clView.dataSource = self as! UICollectionViewDataSource
        clView.delegate = self as! UICollectionViewDelegate
        let nibname = UINib(nibName: "celll", bundle: nil)
        //        clView.register(nibname, forCellWithReuseIdentifier: "menuCell")
        // Do any additional setup after loading the view, typically from a nib.
        menuArr = Array(self.realm.objects(Item.self))
        print(realm.configuration.fileURL)
        print(menuArr)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell =  collectionView.dequeueReusableCell(withReuseIdentifier: "colcell", for: indexPath) as? CollectionViewCell {
            let item123: Item
            item123 = menuArr[indexPath.row]
            var url = menuArr[indexPath.row].photo_url
            if url  == ""{
                url = "https://socialsharing.info/wp-content/uploads/reebok-unveils-new-delta-logo-logo-designer-reebok-symbol-meaning.jpg"
            }
            DispatchQueue.main.async{
                Alamofire.request(url).responseImage {
                response in
                if let image = response.result.value {
                    itemCell.imageView.image = image
                    print(image)
                }
            }
            }
            itemCell.nameLabel.text = item123.item_name
            
            
            return itemCell
        }
        return UICollectionViewCell()
    }
    
    

}
