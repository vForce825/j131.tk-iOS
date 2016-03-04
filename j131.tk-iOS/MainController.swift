//
//  MainController.swift
//  j131.tk-iOS
//
//  Created by Daniel on 16/3/1.
//  Copyright © 2016年 Daniel. All rights reserved.
//

import UIKit

class MainController: UITableViewController, UIDocumentInteractionControllerDelegate {
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
        self.tabBarController?.tabBar.hidden = false;
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
            do {
                let remotePath = fileList![indexPath.row].Path;
                let localFilePath = NSTemporaryDirectory().stringByAppendingString(remotePath.substringFromIndex(path.startIndex.advancedBy(1)).stringByReplacingOccurrencesOfString("/", withString: "_"));
                //for local static cache
                let localMd5hash = FileMD5HashCreateWithPath(localFilePath as CFStringRef, 4096);//It will be nil if the file doesn't exist
                var params = Dictionary<String, String>();
                params["path"] = remotePath;
                let remoteMd5Hash = ApiRequest.get(ApiRequest.FILE_CHECKSUM, params: params)?.objectForKey("msg");
                //When server failed to respond a checksum, we will re-fetch the file
                if (localMd5hash == nil || remoteMd5Hash == nil || (remoteMd5Hash != nil && localMd5hash.takeUnretainedValue() as String != remoteMd5Hash as! String)) {
                    let fileContent = try HttpRequest.get("http://www.j131.tk" + remotePath);
                    if (fileContent == nil) {
                        self.showError("下载失败", message: "服务器返回了空数据，请稍后重试！");
                    }
                    fileContent!.writeToFile(localFilePath, atomically: true);
                }
                let localUrl = NSURL(fileURLWithPath: localFilePath);
                previewFile(localUrl);
            } catch {
                self.showError("打开失败", message: "下载文件时遇到错误！请重试！");
            }
        }
    }
    
    //UIDocumentInteractionController Delegate Function
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self.navigationController!;
    }
    
    func previewFile(localURL: NSURL) {
        let docInteractionVC = UIDocumentInteractionController(URL: localURL);
        docInteractionVC.delegate = self;
        self.tabBarController!.tabBar.hidden = true;
        let otherCanOpen:Bool = docInteractionVC.presentPreviewAnimated(true);
        if (!otherCanOpen) {
            self.showError("无法打开文件", message: "没有对应的应用程序可以打开此文件！");
        }
        self.navigationItem.leftBarButtonItem?.target = "showTabBar";
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
    
    func showTabBar() {
        self.tabBarController?.tabBar.hidden = false;
    }
}
