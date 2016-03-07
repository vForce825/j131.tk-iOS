//
//  SettingController.swift
//  j131.tk
//
//  Created by Daniel on 16/3/4.
//  Copyright © 2016年 Daniel. All rights reserved.
//

import UIKit

class SettingController: UIViewController {
    @IBOutlet weak var clearCacheButton: UIButton!
    
    @IBAction func clearCacheButtonPressed(sender: AnyObject) {
        let cacheSize = FileCache.clearAll();
        let alert = UIAlertController.init(title: "清除缓存", message: "清除成功！共清除\(cacheSize)缓存", preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil));
        self.presentViewController(alert, animated: true, completion: nil);
    }
}
