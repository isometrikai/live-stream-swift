//
//  Date+Extension.swift
//  ISOMetrikSDK
//
//  Created by Rahul Sharma on 20/06/21.
//  Copyright © 2021 Appscrip. All rights reserved.
//

import Foundation

extension Date {
    
    public func ism_toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    public func ism_getCustomMessageTime(dateFormat: String = "dd/MM/yy") -> String {
        let inToday = Calendar.current.isDateInToday(self)
        let isYesterday = Calendar.current.isDateInYesterday(self)
        
        let time = self.ism_toString(format: "hh:mm a")
        let date = self.ism_toString(format: dateFormat)
        
        if inToday {
            return "Today, \(time)"
        }
        
        if isYesterday {
            return "Yesterday, \(time)"
        }
        
        return "\(date)"
    }
    
    public func minuteDifferenceBetween(_ withDate: Date) -> CGFloat {

        //get both times sinces refrenced date and divide by 60 to get minutes
        let newDateMinutes = withDate.timeIntervalSinceReferenceDate/60
        let oldDateMinutes = self.timeIntervalSinceReferenceDate/60

        //then return the difference
        return CGFloat(newDateMinutes - oldDateMinutes)
    }
    
    public func ism_timeAgoDisplay() -> String {
     
            let calendar = Calendar.current
            let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
            let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
            let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

            if minuteAgo < self {
                let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
                return "\(diff) sec ago"
            } else if hourAgo < self {
                let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
                return "\(diff) min ago"
            } else if dayAgo < self {
                let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
                return "\(diff) hrs ago"
            } else if weekAgo < self {
                let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
                return "\(diff) days ago"
            }
            let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
            return "\(diff) weeks ago"
        }
    
}


