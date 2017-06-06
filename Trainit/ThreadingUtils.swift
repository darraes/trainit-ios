//
//  ThreadingUtils.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/27/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation

func synced<T>(_ lock: Any, _ closure: () -> T) -> T{
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return closure()
}
