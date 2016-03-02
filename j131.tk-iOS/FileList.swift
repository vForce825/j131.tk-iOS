//
//  CachedFolders.swift
//  j131.tk
//
//  Created by Daniel on 15/10/29.
//  Copyright © 2015年 Daniel. All rights reserved.
//

import Foundation

class FileList {
    private var keys:[String]?;
    private var webFiles:Dictionary<String, WebFile> = Dictionary<String, WebFile>();
    init(files:NSDictionary) {
        keys = files.keyEnumerator().allObjects as? [String];
        if keys != nil {
            for key in keys! {
                webFiles[key] = WebFile(name: key, path: files.valueForKey(key) as! String);
            }
        }
    }
    var count:Int {
        get {
            return webFiles.count;
        }
    }
    func getFileName(index: Int) -> String {
        return keys![index];
    }
    subscript(fileName: String) -> WebFile {
        get {
            return webFiles[fileName]!;
        }
    }
    subscript(fileIndex: Int) -> WebFile {
        get {
            return webFiles[self.getFileName(fileIndex)]!;
        }
    }
    
}

class WebFile {
    static let TYPE_FOLDER = 1;
    static let TYPE_FILE = 2;
    private var _name:String?;
    private var _path:String?;
    private var _type:Int?;
    init(name: String, path:String) {
        _name = name;
        _path = path;
        _type = path.substringWithRange(Range(start: path.endIndex.advancedBy(-1), end: path.endIndex)) == "/" ? WebFile.TYPE_FOLDER : WebFile.TYPE_FILE;
    }
    var Name:String {
        get {
            return _name!;
        }
    }
    var Path:String {
        get {
            return _path!;
        }
    }
    var URL:String {
        get {
            return "http://www.j131.tk" + _path!;
        }
    }
    var Type:Int {
        get {
            return _type!;
        }
    }
    func showType() -> String {
        var mapping = Dictionary<Int, String>();
        mapping[WebFile.TYPE_FOLDER] = "文件夹";
        mapping[WebFile.TYPE_FILE] = "文件";
        return mapping[_type!]!;
    }
}