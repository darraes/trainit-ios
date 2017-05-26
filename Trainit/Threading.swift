//
//  Threading.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/24/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation

func synced(_ lock: Any, _ closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
