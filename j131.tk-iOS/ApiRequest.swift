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
    static func get(url: String, params: Dictionary<String, String>?) -> AnyObject? {
        let urlComponents = NSURLComponents(string: url);
        var queryItems:[NSURLQueryItem] = [];
        if (params != nil) {
            for (key, value) in params! {
                queryItems.append(NSURLQueryItem(name: key, value: value));
            }
        }
        urlComponents?.queryItems = queryItems;
        var httpResult:NSData?;
        do {
            httpResult = try HttpRequest.get(urlComponents!.string!);
            let json = try NSJSONSerialization.JSONObjectWithData(httpResult!, options: []);
            return json;
        } catch {
            return nil;
        }
    }
}