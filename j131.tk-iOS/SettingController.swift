//
//  SettingController.swift
//  j131.tk
//
//  Created by Daniel on 16/3/4.
//  Copyright © 2016年 Daniel. All rights reserved.
//

import UIKit

class SettingController: UITableViewController {
    let greyBgColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0);
    var actions:Dictionary<Int, Dictionary<Int, Array<Any>>> = [
        0 : [
            0 : ["清除缓存", clearCache],
        ],
    ];
    
    override func viewDidLoad() {
        self.tableView.backgroundColor = self.greyBgColor;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return actions.count;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions[section]!.count;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "";
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0;
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = self.greyBgColor;
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (section != actions.count-1) {
            return nil;
        }
        let view = UIView();
        view.backgroundColor = self.greyBgColor;
        return view;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil);
        cell.textLabel?.text = actions[indexPath.section]![indexPath.row]![0] as? String;
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true);
        let function = actions[indexPath.section]![indexPath.row]![1] as! SettingController->()->();
        function(self)();
    }
    
    func clearCache() {
        let size = FileCache.clearAll();
        let alert = UIAlertController.init(title: "清除缓存", message: "清除了\(size)缓存！", preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil));
        self.presentViewController(alert, animated: true, completion: nil);
    }
}
