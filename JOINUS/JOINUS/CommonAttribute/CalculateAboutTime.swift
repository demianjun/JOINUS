//
//  CommonMethods.swift
//  JOINUS
//
//  Created by Demian on 2021/09/14.
//

import UIKit

class CalculateAboutTime {
  
  func calculateStartTime(start time: String) -> String {
    let dateFormat = DateFormatter()
    dateFormat.locale = Locale(identifier: "Ko_kr")
    dateFormat.dateFormat = "yyyy-MM-dd"// HH-mm-ss"
    
    let dateFormat1 = DateFormatter()
    dateFormat1.locale = Locale(identifier: "Ko_kr")
    dateFormat1.dateFormat = "yyyy-MM-dd HH-mm-ss"
    
    var second = Int()
    
    let currentDate = Date(),
        currentDayString = dateFormat.string(from: currentDate).components(separatedBy: " ")[0],
        currentDay = dateFormat.date(from: currentDayString)!
    
    let startDate = dateFormat1.date(from: time)!,
        startDayString = time.components(separatedBy: " ")[0],
        startDay = dateFormat.date(from: startDayString)!
    
    let dateInterval = startDate - currentDate,//currentDate.distance(to: dateFormat1.date(from: time)!),
        dayInterval = startDay - currentDay//currentDay1.distance(to: startDay1)
    
    if dayInterval == 0 {
      
      second = Int(dateInterval)
     
    } else if (60 <= dayInterval), (dayInterval <= (60 * 60 * 24)) {
      
      second = Int(dayInterval)
      
    } else if (60 * 60 * 24) < dayInterval {
      
      second = Int(dayInterval)
      
    }
    
    return self.calculateStartTimeInterval(second: second)
  }
  
  private func calculateStartTimeInterval(second: Int) -> String {
    var day = String()
    
    if (60 <= second), (second < (60 * 60 * 24)) {
      
      day = "오늘 시작"
      
    } else if ((60 * 60 * 24) <= second), (second < (60 * 60 * 24 * 2)) {
      
      day = "내일 시작"
      
    } else if (60 * 60 * 24 * 2) <= second {
      
      day = "\(Int(second / (60 * 60 * 24)))일 뒤"
      
    } else if second <= 0 {
      
      day = "매칭 완료"
      
    }
    
    return day
  }
  
  func calculateCreatedTime(created time: String) -> String {
    
    let dateFormat = DateFormatter().then {
      $0.locale = Locale(identifier: "Ko_kr")
      $0.dateFormat = "yyyy-MM-dd HH-mm-ss"
    },
    currentDate = Date(),
    createdDate = dateFormat.date(from: time) ?? Date()
        
    let temp = currentDate - createdDate
    
    return self.calculateCreatedTimeInterval(second: Int(temp))
  }
  
  private func calculateCreatedTimeInterval(second: Int) -> String {
    var timeInterval = String()
    
    if second == 0 {
      
      timeInterval = "방금 전"
      
    } else if (60 <= second), (second < 3600) {
      
      timeInterval = "\(Int(second / 60))분 전"
      
    } else if (360 <= second), (second < (60 * 60 * 24)) {
      
      timeInterval = "\(Int(second / 3600))시간 전"
      
    } else if ((60 * 60 * 24) <= second), (second < (60 * 60 * 24 * 2)) {
      
      timeInterval = "어제"
      
    } else if (60 * 60 * 24 * 2) <= second {
      
      timeInterval = "\(Int(second / (60 * 60 * 24)))일 전"
    }
    
    return timeInterval
  }
  
  func dateToString(_ date: Date) -> String {
    let dateFormatter = DateFormatter().then {
      $0.locale = Locale(identifier: "Ko_kr")
      $0.dateFormat = "yyyy년 M월 dd일"
    }
    var setDate = String()
    
    setDate = dateFormatter.string(from: date)
    
    return setDate
  }
  
  func strDateToString(_ date: String) -> String {
    let dateFormatter = DateFormatter().then {
      $0.locale = Locale(identifier: "Ko_kr")
      $0.dateFormat = "yyyy년 M월 dd일"
    }
    
    var setDate = String()
    
    let tempStr = date.components(separatedBy: " ")[0].toDate()
    
    setDate = dateFormatter.string(from: tempStr!)

    return setDate
  }
}
