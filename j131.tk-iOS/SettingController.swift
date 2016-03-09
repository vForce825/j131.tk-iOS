//
//  SettingController.swift
//  j131.tk
//
//  Created by Daniel on 16/3/4.
//  Copyright © 2016年 Daniel. All rights reserved.
//

import UIKit

class SettingController: UITableViewController {
    var sections:Dictionary<Int, String> = [0 : "缓存"]; //section编号必须从0开始
    var actions:Dictionary<Int, Dictionary<Int, Array<Any>>> = [
        0 : [
            0 : ["清除缓存", clearCache],
        ],
    ];
    
    override func viewDidLoad() {
        self.tableView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0);
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count;
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
        view.tintColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0);
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView();
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0);
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
