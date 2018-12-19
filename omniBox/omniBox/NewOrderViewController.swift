//
//  NewOrderViewController.swift
//  omniBox
//
//  Created by Ибрагим on 19/12/2018.
//  Copyright © 2018 bmstu. All rights reserved.
//

import UIKit

class NewOrderViewController: UIViewController {

    
    @IBOutlet weak var segment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var manualOrderView: UIView!
    @IBOutlet weak var qrCodeOrderView: UIView!
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 1:
            manualOrderView.isHidden = false
            qrCodeOrderView.isHidden = true
        case 0:
            manualOrderView.isHidden = true
            qrCodeOrderView.isHidden = false
        default:
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
