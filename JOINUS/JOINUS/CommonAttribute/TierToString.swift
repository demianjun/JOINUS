//
//  File.swift
//  JOINUS
//
//  Created by Demian on 2021/09/14.
//

import UIKit

class TierToString {
  func toString(tier: Int) -> String {
    var tierStr = String()
    
    if tier == 0 {
      
      tierStr = "아이언"
      
    } else if tier == 1 {
      
      tierStr = "브론즈"
      
    } else if tier == 2 {
      
      tierStr = "실버"
      
    } else if tier == 3 {
      
      tierStr = "골드"
      
    } else if tier == 4 {
      
      tierStr = "플래티넘"
      
    } else if tier == 5 {
      
      tierStr = "다이아"
      
    } else if tier == 6 {
      
      tierStr = "마스터"
      
    } else if tier == 7 {
      
      tierStr = "챌린저"
      
    }
    
    return tierStr
  }
  
  func selectTierRange(lowest: Int, highest: Int) -> [String] {
    var lowestTier = String(),
        highestTier = String(),
        tierRange = [String]()
    
      if lowest == 0 { // 아이언 이상
        
        lowestTier = "아이언 이상"
        
      } else if lowest == 1 {
        
        lowestTier = "브론즈 이상"
        
      } else if lowest == 2 {
        
        lowestTier = "실버 이상"
        
      } else if lowest == 3 {
        
        lowestTier = "골드 이상"
        
      } else if lowest == 4 {
        
        lowestTier = "플래티넘 이상"
        
      } else if lowest == 5 {
        
        lowestTier = "다이아 이상"
        
      } else if lowest == 6 {
        
        lowestTier = "마스터 이상"
        
      } else if lowest == 7 {
        
        lowestTier = "챌린저 이상"
        
      } else if lowest == -1 {
        
        lowestTier = "모두 가능"// 모두 가능
        
      }
      
      if highest == 0 { // 아이언 이하
        
        highestTier = "아이언 이하"
        
      } else if highest == 1 {
        
        highestTier = "브론즈 이하"
        
      } else if highest == 2 {
        
        highestTier = "실버 이하"
        
      } else if highest == 3 {
        
        highestTier = "골드 이하"
        
      } else if highest == 4 {
        
        highestTier = "플래티넘 이하"
        
      } else if highest == 5 {
        
        highestTier = "다이아 이하"
        
      } else if highest == 6 {
        
        highestTier = "마스터 이하"
        
      } else if highest == 7 {
        
        highestTier = "챌린저 이하"
        
      } else if highest == -1 {
        
        highestTier = "모두 가능"// 모두 가능
        
      }
      
      tierRange.insert(lowestTier,
                       at: 0)
      tierRange.insert(highestTier,
                       at: 1)
      
    if lowest == -1, highest != -1 {
      
      tierRange.remove(at: 0)
      
    } else if lowest != -1, highest == -1 {
      
      tierRange.remove(at: 1)
      
    } else if lowest > highest {
      
      tierRange = ["모두 가능"]
      
    } else if lowest == -1, highest == -1 {
      
      tierRange = ["모두 가능"]
      
    }
    
    return tierRange
  }
}
