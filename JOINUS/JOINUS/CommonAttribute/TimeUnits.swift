//
//  TimeUnits.swift
//  JOINUS
//
//  Created by Demian on 2021/09/08.
//

import Foundation

class TimeUnits {
  enum time {
    case unit
    
    private func presentTimeStamp() -> [String] {
      let dateFormat = DateFormatter().then {
        $0.locale = Locale(identifier: "Ko_kr")
        $0.dateFormat = "y M d E H mm ss"
      }
      
      let dateElement = dateFormat
        .string(from: Date())
        .components(separatedBy: " ")
      
      return dateElement
    }
  
    var year: Int {
      guard let year = Int(presentTimeStamp()[0]) else { fatalError("year error") }
      return year
    }
    
    var month: Int {
      guard let month = Int(presentTimeStamp()[1]) else { fatalError("month error") }
      return month
    }
    
    var day: Int {
      guard let day = Int(presentTimeStamp()[2]) else { fatalError("day error") }
      return day
    }
    
    var dayOfWeek: String {
      let dayOfWeek = presentTimeStamp()[3]
      return dayOfWeek
    }
    
    var hour: Int {
      guard let hour = Int(presentTimeStamp()[4]) else { fatalError("day error") }
      return hour
    }
      
    var minute: Int {
      guard let min = Int(presentTimeStamp()[5]) else { fatalError("day error") }
      return min
    }

    var second: Int {
      guard let sec = Int(presentTimeStamp()[6]) else { fatalError("day error") }
      return sec
    }
    
    var date: String {
      return "\(month)월 \(day)일 \(dayOfWeek)요일"
    }
    
    var currentDate: String {
      
      var m = String(),
          d = String(),
          date = String()
      
      if month < 10 {
        
       m = "0\(month)"
        
      } else if month >= 10 {
        
        m = "\(month)"
      }
      
      if day < 10 {
        
        d = "0\(day)"
        
      } else if day >= 10 {
        
        d = "\(day)"
      }
      
      date = "\(year)-\(m)-\(d)"
      
      return date
    }
    
    var currentTime: String {
      let time = "\(hour): \(minute): \(second)"
      
      return time
    }
  }
}
