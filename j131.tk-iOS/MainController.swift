//
//  MainController.swift
//  j131.tk-iOS
//
//  Created by Daniel on 16/3/1.
//  Copyright © 2016年 Daniel. All rights reserved.
//

import UIKit

class MainController: UITableViewController {
    private var fileList:FileList?;
    private var alertQueue:Queue<UIAlertController> = Queue<UIAlertController>();
    internal var path:String = "/";
    
    override func viewDidLoad() {
        self.tableView.registerNib(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell");
        self.tableView.registerClass(ItemCell.self, forCellReuseIdentifier: "itemCellClass");
        fileList = downloadFileList(self.path);
    }
    
    override func viewDidAppear(animated: Bool) {
        while (alertQueue.Count != 0) {
            self.presentViewController(alertQueue.Pop(), animated: true, completion: nil);
        }
    }
    
    //TableView Data Source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList!.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell;
        cell.loadImage(fileList![indexPath.row].Type == WebFile.TYPE_FOLDER);
        cell.itemName?.text = fileList![indexPath.row].Name;
        return cell;
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (fileList![indexPath.row].Type == WebFile.TYPE_FOLDER) {
            let newVC = MainController();
            newVC.title = fileList![indexPath.row].Name;
            newVC.path = fileList![indexPath.row].Path;
            newVC.tableView.rowHeight = self.tableView.rowHeight;
            self.navigationController?.pushViewController(newVC, animated: true);
        } else {
            
        }
    }
    
    //Tool Functions
    func downloadFileList(path: String) -> FileList {
        var params = Dictionary<String, String>();
        params["path"] = path;
        let response = ApiRequest.get(ApiRequest.LIST_FOLDER, params: params);
        if (response == nil) {
            showError("网络错误", message: "没有接收到服务器返回信息，请返回或退出重试");
            return self.fileList == nil ? FileList(files: NSDictionary()) : self.fileList!;
        }
        if (response?.objectForKey("succ") == nil) {
            showError("数据解析错误", message: "没有收到规范的返回内容，请返回或退出重试");
            return self.fileList == nil ? FileList(files: NSDictionary()) : self.fileList!;
        }
        if (response?.objectForKey("succ") as! String == "0") {
            showError("服务器错误", message: "服务器处理列表请求失败，请返回或退出重试");
            return self.fileList == nil ? FileList(files: NSDictionary()) : self.fileList!;
        }
        return FileList(files: response?.objectForKey("msg") as! NSDictionary);
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil));
        if (self.isViewLoaded() && (self.view.window != nil)) {
            self.presentViewController(alert, animated: true, completion: nil);
        } else {
            alertQueue.Push(alert);
        }
    }
}
