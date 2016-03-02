//
//  Stack.swift
//  j131.tk
//
//  Created by Daniel on 15/10/31.
//  Copyright © 2015年 Daniel. All rights reserved.
//

import Foundation

struct Stack<T> {
    var items = [T]();
    mutating func Push(item: T) {
        items.append(item);
    }
    mutating func Pop() -> T {
        return items.removeLast();
    }
    var Count:Int {
        get {
            return items.count;
        }
    }
}