//
//  HttpRequest.swift
//  j131.tk
//
//  Created by Daniel on 15/10/28.
//  Copyright © 2015年 邱家辉. All rights reserved.
//

import Foundation
import UIKit

class HttpRequest {
    static func get(url: String) throws -> NSData? {
        let request = NSURLRequest(URL: NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!);
        var data: NSData?;
        try data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil);
        return data;
    }
    
    static func getAsync(url: String, completionHandler: (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void)
    {
        let request = NSURLRequest(URL: NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!);
        let queue = NSOperationQueue.mainQueue();
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: completionHandler);
    }
}