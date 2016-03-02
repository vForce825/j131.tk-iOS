//
//  Queue.swift
//  j131.tk
//
//  Created by Daniel on 15/11/2.
//  Copyright © 2015年 Daniel. All rights reserved.
//

import Foundation

struct Queue<T> {
    var items = [T]();
    mutating func Push(item: T) {
        items.append(item);
    }
    mutating func Pop() -> T {
        return items.removeFirst();
    }
    var Count:Int {
        get {
            return items.count;
        }
    }
}