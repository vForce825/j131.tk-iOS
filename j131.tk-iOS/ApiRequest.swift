//
//  ApiRequest.swift
//  j131.tk
//
//  Created by Daniel on 15/10/29.
//  Copyright © 2015年 Daniel. All rights reserved.
//

import Foundation
import UIKit
class ApiRequest {
    static let LIST_COUNT = "https://api.j131.tk/api/listCount";
    static let LIST_FOLDER = "https://api.j131.tk/api/listFolder";
    static let FILE_CHECKSUM = "https://api.j131.tk/api/fileChecksum";
    static func get(url: String, params: Dictionary<String, String>?) -> AnyObject? {
        if (Reachability().connectionStatus() == ReachabilityStatus.Offline) {
            return nil;
        }
        let requestURL = url + self.createGetParam(params);
        var httpResult:NSData?;
        do {
            httpResult = try HttpRequest.get(requestURL);
            let json = try NSJSONSerialization.JSONObjectWithData(httpResult!, options: []);
            return json;
        } catch {
            return nil;
        }
    }
    static func getAsync(url:String, params: Dictionary<String, String>?, completionHandler:(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void) {
        let requestURL = url + self.createGetParam(params);
        HttpRequest.getAsync(requestURL, completionHandler: completionHandler);
    }
    
    static private func createGetParam(params: Dictionary<String, String>?) -> String {
        if (params == nil) {
            return "";
        }
        var url = "?";
        for (key, value) in params! {
            url += "\(key)=\(value)&";
        }
        url = url.substringToIndex(url.endIndex.advancedBy(-1));
        return url;
    }
}