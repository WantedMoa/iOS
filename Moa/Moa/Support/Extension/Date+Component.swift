//
//  Date+.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

extension Date {
    func component(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
