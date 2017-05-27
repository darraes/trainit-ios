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

func date(for strDate: String) -> Date {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd";
    return fmt.date(from: strDate)!
}

func dateStr(for date: Date) -> String {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd";
    return fmt.string(from: date)
}

func weekDay(for date: Date) -> String {
    let fmt = DateFormatter()
    fmt.dateFormat = "E";
    return fmt.string(from: date)
}
