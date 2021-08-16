//
//  Extension.swift
//  JOINUS
//
//  Created by Demian on 2021/08/16.
//

import UIKit

extension UIView {
  func parentView<T: UIView>(of type: T.Type) -> T? {
    guard let view = superview else {
      return nil
    }
    return (view as? T) ?? view.parentView(of: T.self)
  }
  
  func castingType<T: UIView>(of type: T.Type) -> T? {
    let view = self
    
    return (view as? T) ?? view.castingType(of: T.self)
  }
  
  var parentViewController: UIViewController? {
    var responder: UIResponder? = self
    while let nextResponder = responder?.next {
      responder = nextResponder
      if let viewController = nextResponder as? UIViewController {
        return viewController
      }
    }
    return nil
  }
  
  func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
    clipsToBounds = true
    layer.cornerRadius = cornerRadius
    layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
  }
}

extension UIImage {
  convenience init(view: UIView) {
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.render(in:UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: image!.cgImage!)
  }
}

extension UILabel {
  func halfTextColorChange(fullText: String , changeText: String, color: UIColor, size: CGFloat, isSpacing: Bool? = nil) {
    let strNumber: NSString = fullText as NSString,
        range = (strNumber).range(of: changeText),
        font = CommonFont.shared.font_Bold(size),
        attribute = NSMutableAttributedString.init(string: fullText),
        paragraphStyle = NSMutableParagraphStyle()
    
    attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
    attribute.addAttribute(kCTFontAttributeName as NSAttributedString.Key, value: font, range: range)
    
    if isSpacing ?? false {
      paragraphStyle.lineSpacing = 5
      attribute.addAttribute(NSAttributedString.Key.paragraphStyle,
                             value: paragraphStyle,
                             range: NSMakeRange(0, attribute.length))
    }
    
    self.attributedText = attribute
  }
  
  func lineSpacing(spacing: CGFloat, alignment: NSTextAlignment) {
    let attrString = NSMutableAttributedString(string: self.text ?? ""),
        paragraphStyle = NSMutableParagraphStyle()
        
    paragraphStyle.lineSpacing = spacing
    attrString.addAttribute(NSAttributedString.Key.paragraphStyle,
                            value: paragraphStyle,
                            range: NSMakeRange(0, attrString.length))
    self.attributedText = attrString
    self.textAlignment = alignment
  }
}

extension String {
  var localized: String {
    return NSLocalizedString(self,
                             tableName: "localized",
                             value: self,
                             comment: "")
  }
  
  func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
    let dateFormatter = DateFormatter().then {
//      $0.dateFormat = "yyyy-MM-dd-HH:mm:ss"
      $0.dateFormat = "yyyy-MM-dd"
      $0.timeZone = TimeZone(identifier: "Ko_kr")
    }
    
    if let date = dateFormatter.date(from: self) {
      
      return date
      
    } else {

      return nil
      
    }
  }
}

extension Date {
  static func - (lhs: Date, rhs: Date) -> TimeInterval {
    return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
  }
  
  func toString() -> String {
    let dateFormatter = DateFormatter().then {
      $0.dateFormat = "yyyy-MM-dd-HH:mm:ss"
      $0.timeZone = TimeZone(identifier: "Ko_kr")
    }

    return dateFormatter.string(from: self)
  }
}

extension Array {
  subscript (safe index: Int) -> Element? {
    // iOS 9 or later
    return indices ~= index ? self[index] : nil
    // iOS 8 or earlier
    // return startIndex <= index && index < endIndex ? self[index] : nil
    // return 0 <= index && index < self.count ? self[index] : nil
  }
}

extension Array where Element == UIView  {
  static func ~=(pattern: Array, value: Array) -> Bool {
    return pattern == value
  }
}

extension UIControl {
  public typealias UIControlTargetClosure = (UIControl) -> ()
  
  private class UIControlClosureWrapper: NSObject {
    let closure: UIControlTargetClosure
    
    init(_ closure: @escaping UIControlTargetClosure) {
      self.closure = closure
    }
  }
  
  private struct AssociatedKeys {
    static var targetClosure = "targetClosure"
  }
  
  private var targetClosure: UIControlTargetClosure? {
    get {
      guard let closureWrapper =
        objc_getAssociatedObject(self,
                                 &AssociatedKeys.targetClosure) as? UIControlClosureWrapper else { return nil }
      return closureWrapper.closure
    }
    
    set(newValue) {
      guard let newValue = newValue else { return }
      objc_setAssociatedObject(self,
                               &AssociatedKeys.targetClosure,
                               UIControlClosureWrapper(newValue),
                               objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
  }
  
  @objc func closureAction() { guard let targetClosure = targetClosure else { return }
    targetClosure(self) }
  
  public func addAction(for event: UIControl.Event,
                        closure: @escaping UIControlTargetClosure) {
    targetClosure = closure
    addTarget(self, action: #selector(UIControl.closureAction), for: event)
  }
}

extension UIDevice {
  var identifier: String {
    var sysinfo = utsname()
    uname(&sysinfo)
    let data = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
    let identifier = String(bytes: data, encoding: .ascii)!
    return identifier.trimmingCharacters(in: .controlCharacters)
  }

  var modelName: String {
    return modelNameMappingList[identifier] ?? "Unknown"
  }
  
  private var modelNameMappingList: [String: String] {
    return [
      /***************************************************
       iPhone
       ***************************************************/
      "iPhone1,1" : "iPhone",            // (Original)
      "iPhone1,2" : "iPhone",            // (3G)
      "iPhone2,1" : "iPhone",            // (3GS)
      "iPhone3,1" : "iPhone 4",          // (GSM)
      "iPhone3,3" : "iPhone 4",          // (CDMA)
      "iPhone4,1" : "iPhone 4S",         //
      "iPhone5,1" : "iPhone 5",          // (A1428)
      "iPhone5,2" : "iPhone 5",          // (A1429)
      "iPhone5,3" : "iPhone 5c",         // (A1456/A1532)
      "iPhone5,4" : "iPhone 5c",         // (A1507/A1516/A1529)
      "iPhone6,1" : "iPhone 5s",         // (A1433, A1453)
      "iPhone6,2" : "iPhone 5s",         // (A1457, A1518, A1530)
      "iPhone7,1" : "iPhone 6 Plus",     //
      "iPhone7,2" : "iPhone 6",          //
      "iPhone8,1" : "iPhone 6S",         //
      "iPhone8,2" : "iPhone 6S Plus",    //
      "iPhone8,4" : "iPhone SE",         //
      "iPhone9,1" : "iPhone 7",          // (A1660/A1779/A1780)
      "iPhone9,3" : "iPhone 7",          // (A1778)
      "iPhone9,2" : "iPhone 7 Plus",     // (A1661/A1785/A1786)
      "iPhone9,4" : "iPhone 7 Plus",     // (A1784)
      "iPhone10,1": "iPhone 8",          // (A1863/A1906) CDMA
      "iPhone10,4": "iPhone 8",          // (A1905) GSM
      "iPhone10,2": "iPhone 8 Plus",     // (A1864/A1898) CDMA
      "iPhone10,5": "iPhone 8 Plus",     // (A1897) GSM
      "iPhone10,3": "iPhone X",          // (A1865/A1902) CDMA
      "iPhone10,6": "iPhone X",          // (A1901) GSM
      "iPhone11,2": "iPhone XS",         //
      "iPhone11,4": "iPhone XS Max",     //
      "iPhone11,6": "iPhone XS Max",     // China
      "iPhone11,8": "iPhone XR",         //
      "iPhone12,1": "iPhone 11",         //
      "iPhone12,3": "iPhone 11 Pro",     //
      "iPhone12,5": "iPhone 11 Pro Max", //
      "iPhone12,8" : "iPhone SE 2nd Gen",//
      "iPhone13,1" : "iPhone 12 Mini",   //
      "iPhone13,2" : "iPhone 12",        //
      "iPhone13,3" : "iPhone 12 Pro",    //
      "iPhone13,4" : "iPhone 12 Pro Max",//
      "iPad11,1" : "iPad mini 4g",// 아이패드 미니 4세대
    ]
  }
  
  func checkTime() {
    let startTime = CFAbsoluteTimeGetCurrent()
    for _ in 1..<9999999 {  }
    let durationTime = CFAbsoluteTimeGetCurrent() - startTime
    print("-> 경과 시간: \(durationTime)")
  }
}


//extension UISegmentedControl{
//  func removeBorder(){
//    let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor,
//                                                          andSize: self.bounds.size)
//
//    self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
//    self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
//    self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
//
//    let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor,
//                                                       andSize: CGSize(width: 1.0,
//                                                                       height: self.bounds.size.height))
//    self.setDividerImage(deviderImage,
//                         forLeftSegmentState: .selected,
//                         rightSegmentState: .normal,
//                         barMetrics: .default)
//
//    self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray],
//                                for: .normal)
//    self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
//                                for: .selected)
//  }
//
//  func addUnderlineForSelectedSegment(){
//    removeBorder()
//    let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
//    let underlineHeight: CGFloat = 5.0
//    let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
//    let underLineYPosition = self.bounds.size.height - 1.0
//    let underlineFrame = CGRect(x: underlineXPosition,
//                                y: underLineYPosition,
//                                width: underlineWidth,
//                                height: underlineHeight)
//
//    let underline = UIView(frame: underlineFrame)
//    underline.backgroundColor = UIColor.black
//    underline.tag = 599
//    self.addSubview(underline)
//  }
//
//  func changeUnderlinePosition(){
//    guard let underline = self.viewWithTag(599) else {return}
//    let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
//    UIView.animate(withDuration: 0.1, animations: {
//      underline.frame.origin.x = underlineFinalXPosition
//    })
//  }
//}
//
//extension UIImage{
//
//  class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
//    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
//    let graphicsContext = UIGraphicsGetCurrentContext()
//    graphicsContext?.setFillColor(color)
//    let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
//    graphicsContext?.fill(rectangle)
//    let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    return rectangleImage!
//  }
//}
