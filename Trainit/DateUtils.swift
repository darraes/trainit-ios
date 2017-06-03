//
//  Threading.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/24/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation

func timeUtilStr(_ time: TimeUnit) -> String {
    switch time {
    case .second:
        return "Secs"
    default:
        return "Minutes"
    }
}

func toDate(for strDate: String) -> Date {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd";
    return fmt.date(from: strDate)!
}

func dateStr(for date: Date) -> String {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM-dd";
    return fmt.string(from: date)
}

func weekDay(for date: Date) -> Int {
    let calendar = Calendar.current
    return calendar.dateComponents([.weekday], from: date).weekday!
}

func weekDayStr(for date: Date) -> String {
    let fmt = DateFormatter()
    fmt.dateFormat = "E";
    return fmt.string(from: date)
}

func short(for date: Date) -> String {
    let fmt = DateFormatter()
    fmt.dateFormat = "MMdd";
    return fmt.string(from: date)
}

func intervalInDays(for start: Date, and end: Date) -> Int {
    let calendar = Calendar.current
    let distance = calendar.dateComponents([.day], from: start, to: end)
    return distance.day!;
}

