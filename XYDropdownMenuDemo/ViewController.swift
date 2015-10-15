//
//  ViewController.swift
//  XYDropdownMenuDemo
//
//  Created by 潘新宇 on 15/10/5.
//  Copyright © 2015年 潘新宇. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let items = ["列表1", "列表2", "列表3" ,"设置"]
        let BTView = XYDropDownMenu(title: "", items: items)
        //BTView.arrowImage = UIImage(named: "ar")
        BTView.arrowPadding = -15
        BTView.cellHeight = 44
        BTView.cellSeparatorColor = UIColor.clearColor()
        BTView.cellBackgroundColor = UIColor.whiteColor()
        //BTView.checkMarkImage = UIImage(named: "checkmark")
        
        BTView.didSelectItemAtIndexHandler = {(indexPath:Int) -> () in
            print("Clicked \(indexPath)")
            
        }
        
        self.btn.customView = BTView
        
    }



}

