//
//  Log.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/29/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation

class Log {
    static func write(level: String, _ msg: String, _ srcFn: String) {
        print("\(level)\(short(for: Date())) \(srcFn): \(msg)")
    }
    
    static func debug(_ msg: String, _ srcFn: String = #function) {
        Log.write(level: "D", msg, srcFn)
    }
    
    static func info(_ msg: String, _ srcFn: String = #function) {
        Log.write(level: "I", msg, srcFn)
    }
    
    static func warning(_ msg: String, _ srcFn: String = #function) {
        Log.write(level: "W", msg, srcFn)
    }
    
    static func error(_ msg: String, _ srcFn: String = #function) {
        Log.write(level: "E", msg, srcFn)
    }
    
    static func critical(_ msg: String, _ srcFn: String = #function) {
        Log.write(level: "C", msg, srcFn)
    }
}


