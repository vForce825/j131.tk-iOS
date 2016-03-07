//
//  FileCache.swift
//  j131.tk
//
//  Created by Daniel on 16/3/7.
//  Copyright © 2016年 Daniel. All rights reserved.
//

import Foundation

class FileCache {
    internal static let cacheDirectory = NSHomeDirectory().stringByAppendingString("/Library/Caches/");
    
    static func getCachePath(key: String) -> String {
        return self.cacheDirectory.stringByAppendingString(key.substringFromIndex(key.startIndex.advancedBy(1)).stringByReplacingOccurrencesOfString("/", withString: "_"));
    }
    
    static func read(key: String) -> NSURL? {
        if (NSFileManager.defaultManager().fileExistsAtPath(self.getCachePath(key))) {
            return NSURL(fileURLWithPath: self.getCachePath(key));
        } else {
            return nil;
        }
    }
    
    static func write(key: String, data: NSData) {
        self.remove(key);
        data.writeToFile(self.getCachePath(key), atomically: true);
    }
    
    static func remove(key: String) {
        let fileManager = NSFileManager.defaultManager();
        if (fileManager.fileExistsAtPath(self.getCachePath(key))) {
            do {
                try fileManager.removeItemAtPath(self.getCachePath(key));
            } catch {
                
            }
        }
    }
    
    static func clearAll() -> String {
        let fileManager = NSFileManager.defaultManager()
        let cacheURL = NSURL(fileURLWithPath: self.cacheDirectory);
        let enumerator = fileManager.enumeratorAtPath(self.cacheDirectory);
        var cacheSize:Double = 0;
        while let file = enumerator?.nextObject() as? String {
            do {
                let url = cacheURL.URLByAppendingPathComponent(file);
                cacheSize += fileSizeAtPath(url.path!);
                try fileManager.removeItemAtURL(cacheURL.URLByAppendingPathComponent(file));
            } catch {
                
            }
        }
        return self.showFileSize(cacheSize);
    }
    
    static func showFileSize (size:Double) -> String {
        if (size <= 0.1) {
            return "\(String(format: "%.2f",size * 1024))KB";
        } else {
            return "\(String(format: "%.2f", size))MB";
        }
    }
    
    static func fileSizeAtPath(filePath: String) -> Double {
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