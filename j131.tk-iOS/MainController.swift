//
//  MainController.swift
//  j131.tk-iOS
//
//  Created by Daniel on 16/3/1.
//  Copyright © 2016年 Daniel. All rights reserved.
//

import UIKit

class MainController: UITableViewController, UIDocumentInteractionControllerDelegate, NSURLSessionDownloadDelegate {
    private var fileList:FileList?;
    private var alertQueue:Queue<UIAlertController> = Queue<UIAlertController>();
    internal var path:String = "/";
    private var downloadTask:NSURLSessionDownloadTask? = nil;
    private var downloadIndex:NSIndexPath? = nil;
    private var localFilePath:String? = nil;
    private let cacheDirectory = NSHomeDirectory().stringByAppendingString("/Library/Caches/");
    
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
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true);
        if (fileList![indexPath.row].Type == WebFile.TYPE_FOLDER) {
            //打开文件夹
            let newVC = MainController();
            newVC.title = fileList![indexPath.row].Name;
            newVC.path = fileList![indexPath.row].Path;
            newVC.tableView.rowHeight = self.tableView.rowHeight;
            self.navigationController?.pushViewController(newVC, animated: true);
        } else {
            //打开文件
            if (downloadTask == nil) {
                readFile(indexPath, complete: { (localFilePath) in
                    if (NSFileManager.defaultManager().fileExistsAtPath(localFilePath)) {
                        let localUrl = NSURL(fileURLWithPath: localFilePath);
                        self.previewFile(localUrl);
                    } else {
                        self.showError("打开失败", message: "文件读取失败，请检查网络连接");
                    }
                });
            } else {
                if (downloadIndex != indexPath) {
                    self.showError("错误", message: "已经有正在下载的文件，不允许再尝试打开另一个文件！");
                }
            }
        }
    }
    
    
    
    
    //UIDocumentInteractionController Delegate Function
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self.navigationController!;
    }
    
    
    
    
    //NSURLSessionDownload Delegate Function
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let data = NSData(contentsOfURL: location)
        if (data != nil) {
            data!.writeToFile(self.localFilePath!, atomically: true);
            dispatch_async(dispatch_get_main_queue()) {
                self.previewFile(NSURL(fileURLWithPath: self.localFilePath!));
            }
        } else {
            self.showError("下载失败", message: "没有接收到服务器的返回数据，请稍后重试！");
        }
        //Cleaning
        dispatch_async(dispatch_get_main_queue()) {
            (self.tableView!.cellForRowAtIndexPath(self.downloadIndex!) as! ItemCell).progressView.hidden = true;
            (self.tableView!.cellForRowAtIndexPath(self.downloadIndex!) as! ItemCell).cancelButton.hidden = true;
            (self.tableView!.cellForRowAtIndexPath(self.downloadIndex!) as! ItemCell).progressView.progress = 0;
            self.downloadTask = nil;
            self.localFilePath = nil;
            self.downloadIndex = nil;
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        dispatch_async(dispatch_get_main_queue()) {
            (self.tableView!.cellForRowAtIndexPath(self.downloadIndex!) as! ItemCell).progressView.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite);
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        dispatch_async(dispatch_get_main_queue()) {
            if (error != nil && error!.code != -999) {
                self.showError("下载失败", message: error!.localizedDescription);
            }
            //Cleaning
            if (self.downloadIndex != nil) { //to prevent unnecessary clean after complete
                (self.tableView!.cellForRowAtIndexPath(self.downloadIndex!) as! ItemCell).progressView.hidden = true;
                (self.tableView!.cellForRowAtIndexPath(self.downloadIndex!) as! ItemCell).cancelButton.hidden = true;
                (self.tableView!.cellForRowAtIndexPath(self.downloadIndex!) as! ItemCell).progressView.progress = 0;
                self.downloadTask = nil;
                self.downloadIndex = nil;
                self.localFilePath = nil;
            }
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
            self.tabBarController?.tabBar.hidden = false;
        } else {
            alertQueue.Push(alert);
        }
    }
    
    func showTabBar() {
        self.tabBarController?.tabBar.hidden = false;
    }
    
    func readFile(index: NSIndexPath, complete: (String) -> ()) {
        let row = index.row;
        let remotePath = fileList![row].Path;
        let localFilePath = self.cacheDirectory.stringByAppendingString(remotePath.substringFromIndex(path.startIndex.advancedBy(1)).stringByReplacingOccurrencesOfString("/", withString: "_"));
        self.localFilePath = localFilePath;
        //for local static cache
        let localMd5hash = FileMD5HashCreateWithPath(localFilePath as CFStringRef, 4096);//It will be nil if the file doesn't exist
        var params = Dictionary<String, String>();
        params["path"] = remotePath;
        let remoteMd5Hash = ApiRequest.get(ApiRequest.FILE_CHECKSUM, params: params)?.objectForKey("msg");
        //When server failed to respond a checksum, we will re-fetch the file
        //But if the network in unavailable, we'll check if we have its cache
        if (localMd5hash == nil || remoteMd5Hash == nil || (remoteMd5Hash != nil && localMd5hash.takeUnretainedValue() as String != remoteMd5Hash as! String)) {
            if (Reachability().connectionStatus() != ReachabilityStatus.Offline) {
                let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
                self.downloadTask = session.downloadTaskWithURL(HttpRequest.getURL("http://www.j131.tk" + remotePath));
                //显示进度 & 允许取消
                (self.tableView!.cellForRowAtIndexPath(index) as! ItemCell).progressView.hidden = false;
                (self.tableView!.cellForRowAtIndexPath(index) as! ItemCell).cancelButton.hidden = false;
                (self.tableView!.cellForRowAtIndexPath(index) as! ItemCell).registerCancelButtonDownEvent(cancelDownload);
                self.downloadIndex = index;
                self.downloadTask!.resume();
            }
        } else {
            complete(localFilePath); //done for reading cache
        }
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
    
    func cancelDownload() {
        self.downloadTask?.cancel();
    }
}
