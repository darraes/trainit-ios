//
//  Threading.swift
//  Trainit
//
//  Created by Daniel Pereira on 5/24/17.
//  Copyright © 2017 Daniel Arraes. All rights reserved.
//

import Foundation

enum WeekDay: Int
{
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}

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

func weekDay(for date: Date) -> WeekDay {
    let calendar = Calendar.current
    return WeekDay(
        rawValue: calendar.dateComponents([.weekday], from: date).weekday!)!
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

