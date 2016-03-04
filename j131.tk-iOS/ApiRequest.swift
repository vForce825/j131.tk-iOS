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
    static let LIST_COUNT = "http://api.j131.tk/api/listCount";
    static let LIST_FOLDER = "http://api.j131.tk/api/listFolder";
    static let FILE_CHECKSUM = "http://api.j131.tk/api/fileChecksum";
    static func get(url: String, params: Dictionary<String, String>?) -> AnyObject? {
        if (Reachability().connectionStatus() == ReachabilityStatus.Offline) {
            return nil;
        }
        var requestURL = url + "?";
        for (key, value) in params! {
            requestURL += "\(key)=\(value)&";
        }
        requestURL = requestURL.substringToIndex(requestURL.endIndex.advancedBy(-1));
        var httpResult:NSData?;
        do {
            httpResult = try HttpRequest.get(requestURL);
            let json = try NSJSONSerialization.JSONObjectWithData(httpResult!, options: []);
            return json;
        } catch {
            return nil;
        }
    }
}