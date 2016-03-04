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
        let fileManager = NSFileManager.defaultManager()
        let cacheURL = NSURL(fileURLWithPath: NSTemporaryDirectory());
        let enumerator = fileManager.enumeratorAtPath(NSTemporaryDirectory());
        var cacheSize:Double = 0;
        while let file = enumerator?.nextObject() as? String {
            do {
                let url = cacheURL.URLByAppendingPathComponent(file);
                cacheSize += fileSizeAtPath(url.path!);
                try fileManager.removeItemAtURL(cacheURL.URLByAppendingPathComponent(file));
            } catch {
                
            }
        }
        let alert = UIAlertController.init(title: "清除缓存", message: "清除成功！共清\(showFileSize(cacheSize))缓存", preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil));
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    func showFileSize (size:Double) -> String {
        if (size <= 0.1) {
            return "\(String(format: "%.2f",size * 1024))KB";
        } else {
            return "\(String(format: "%.2f", size))MB";
        }
    }
    
    func fileSizeAtPath(filePath: String) -> Double {
        let manager:NSFileManager = NSFileManager.defaultManager();
        if (manager.fileExistsAtPath(filePath )) {
            do {
                return try ((manager.attributesOfItemAtPath(filePath) as NSDictionary)["NSFileSize"] as! Double)/1024/1024;
            } catch {
                return 0;
            }
        }
        return 0;
    }
}
