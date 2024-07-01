//
//  ScheduleStreamView+Timer.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 14/12/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import Foundation

extension ScheduleStreamView {
    
    public func startCountdownTimer() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        let userCalendar = Calendar.current
        // Set Current Date
        let date = Date()
        let components = userCalendar.dateComponents([.hour, .minute, .month, .year, .day, .second], from: date)
        let currentDate = userCalendar.date(from: components)!
        
        // Convert eventDateComponents to the user's calendar
        guard let eventDate = self.scheduleEventDate else { return }
        
        // Change the seconds to days, hours, minutes and seconds
        let timeLeft = userCalendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: eventDate)
        
        self.timeLabel.text = "\(timeLeft.day!)d \(timeLeft.hour!)h \(timeLeft.minute!)m \(timeLeft.second!)s"
        
        endEvent(currentdate: currentDate, eventdate: eventDate)
        
    }
    
    func endEvent(currentdate: Date, eventdate: Date) {
        if currentdate >= eventdate {
            // Stop Timer
            timer?.invalidate()
            timeLabel.text = ""
            self.manageData()
        }
    }
    
}
