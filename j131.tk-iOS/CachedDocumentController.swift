//
//  CachedDocumentController.swift
//  j131.tk
//
//  Created by Daniel on 16/3/23.
//  Copyright © 2016年 Daniel. All rights reserved.
//

import UIKit

class CachedDocumentController: UITableViewController, UIDocumentInteractionControllerDelegate {
    var fileCache:FileCache = FileCache();

    override func viewDidLoad() {
        super.viewDidLoad();
        self.clearsSelectionOnViewWillAppear = false;
        self.title = "查看缓存";
        self.tableView.registerNib(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell");
        self.tableView.registerClass(ItemCell.self, forCellReuseIdentifier: "itemCellClass");
        self.tableView.rowHeight = 53;
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIDocumentInteractionController Delegate Function
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self.navigationController!;
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileCache.fileCount();
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell;
        cell.loadImage(false);
        cell.itemName?.text = fileCache[indexPath.row];
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true);
        self.previewFile(FileCache.read("/"+fileCache[indexPath.row])!);
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    func previewFile(localURL: NSURL) {
        let docInteractionVC = UIDocumentInteractionController(URL: localURL);
        docInteractionVC.delegate = self;
        self.tabBarController!.tabBar.hidden = true;
        let otherCanOpen:Bool = docInteractionVC.presentPreviewAnimated(true);
        if (!otherCanOpen) {
            self.showError("无法打开文件", message: "没有对应的应用程序可以打开此文件！");
        }
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil));
        self.presentViewController(alert, animated: true, completion: nil);
        self.tabBarController?.tabBar.hidden = false;
    }
}
