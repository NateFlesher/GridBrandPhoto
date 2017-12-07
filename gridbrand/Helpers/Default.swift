//
//  Default.swift
//  gridbrand
//
//  Created by LionStar on 1/8/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
    typealias Image = UIImage
#elseif os(macOS)
    import Cocoa
    import AppKit
    typealias Image = NSImage
#endif

let MB = 1024 * 1024
let RAINBOW_COLOR_MAX:Float = 256 * 6 - 1

struct GbColor {
    static let yellow = UIColor(hex: "#F6A623")
    static let lightGray = UIColor(hex:"#9B9B9B")
    static let purple = UIColor(hex: "9012FE")
    static let blue = UIColor(hex: "4990E2")
    static let green = UIColor(hex: "50E3C2")
    static let darkGray = UIColor(hex: "4A4A4A")
}
func apiError(_ error: String, code: Int = -1, location: String = "\(#file):\(#line)") -> NSError {
    return NSError(domain: "ExampleError", code: code, userInfo: [NSLocalizedDescriptionKey: "\(location): \(error)"])
}

extension String {
    func toFloat() -> Float? {
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: self)?.floatValue
    }
    
    func toDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: self)?.doubleValue
    }
}

func showAlert(_ message: String) {
    #if os(iOS)
        UIAlertView(title: "RxExample", message: message, delegate: nil, cancelButtonTitle: "OK").show()
    #elseif os(macOS)
        let alert = NSAlert()
        alert.messageText = message
        alert.runModal()
    #endif
}

// My Extensions
extension Array {
    func sample() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
}

extension Date {
    var relativeTime: String {
        let now = Date()
        
        let calendar = NSCalendar.current
        
        let unitFlags = Set<Calendar.Component>([Calendar.Component.year, .month, .weekOfMonth, .weekdayOrdinal, .weekday, .day, .hour, .minute])
        
        
        let meDateComponent = calendar.dateComponents(unitFlags, from: self)
        let nowDateComponent = calendar.dateComponents(unitFlags, from: now)
        
        let dayOfYearForMe = calendar.ordinality(of: Calendar.Component.day, in: Calendar.Component.year, for: self)
        let dayOfYearForNow = calendar.ordinality(of: Calendar.Component.day, in: Calendar.Component.year, for: now)
        
        
        
        
        let dateFormatter = DateFormatter();
        
        if (meDateComponent.year == nowDateComponent.year && meDateComponent.month == nowDateComponent.month && meDateComponent.day == nowDateComponent.day)
        {            
            dateFormatter.timeStyle = DateFormatter.Style.short
            return dateFormatter.string(from: self)
        }
        else if (meDateComponent.year! == nowDateComponent.year && dayOfYearForMe == (dayOfYearForNow!-1))
        {
            return "Yesterday"
        }
        else if (meDateComponent.year == nowDateComponent.year && dayOfYearForMe! > (dayOfYearForNow!-6))
        {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self)
        }
        else
        {
            
            let localeFormatString = DateFormatter.dateFormat(fromTemplate: "ddMMyy", options: 0, locale: Locale.current)
            dateFormatter.dateFormat = localeFormatString
            
            return dateFormatter.string(from: self)
        }
    }
}

extension UIView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

func showSignupEmailSentConfirmPopup(parentView:UIView, email: String, completion:@escaping (_ user:UserModel)->Void) {
    let frame = parentView.frame
    let view = GbSignupEmailSentView(frame: CGRect(x:0, y:0, width:frame.size.width-40, height:400))
    view.layer.cornerRadius = 12
    view.layer.masksToBounds = true
    
    let layout = KLCPopupLayoutMake(.center, .center)
    
    let popup:KLCPopup = KLCPopup(contentView: view, showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
    
    view.parentPopup = popup
    
    popup.show(with: layout)
    
    view.emailLabel.text = email
    view.confirmedHandler = { user in
        completion(user)
    }
}

func showReportDialog(for cycle:CycleModel, on parentView:UIView) {
    let frame = parentView.frame
    let view = GbReportView(frame: CGRect(x:8, y:0, width:frame.size.width-16, height:238))
    view.layer.cornerRadius = 6
    view.layer.masksToBounds = true
    
    let layout = KLCPopupLayoutMake(.center, .bottom)
    
    let popup:KLCPopup = KLCPopup(contentView: view, showType: .bounceInFromBottom, dismissType: .bounceOutToBottom, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
    
    view.parentPopup = popup
    view.cycle = cycle
    view.completionHandler = { result in
        //completion(result)
    }
    popup.show(with: layout)
}

func showWhyMagicPopup(on parentView:UIView, callback: @escaping () -> Void) {
    
    let frame = parentView.frame
    let view = GbWhyMagicView(frame: CGRect(x:8, y:0, width:frame.size.width-16, height:175))
    view.layer.cornerRadius = 6
    view.layer.masksToBounds = true
    
    let layout = KLCPopupLayoutMake(.center, .center)
    
    let popup:KLCPopup = KLCPopup(contentView: view, showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
    
    view.parentPopup = popup
    view.completionHandler = {
        callback()
    }
    
    popup.show(with: layout)
}

// x: 0 ~ 256 * 6 - 1
func rainbowColor(x: Float) -> UIColor {
    let unit:Float = 256
    var r:Float = 0, g:Float = 0, b:Float = 0
    if ( 0 <= x && x < unit) {
        r = unit - 1
        g = x
    } else if (x < unit * 2) {
        r = unit - 1 - x.truncatingRemainder(dividingBy: unit)
        g = unit - 1
    } else if (x < unit * 3) {
        g = unit - 1
        b = x.truncatingRemainder(dividingBy: unit)
    } else if (x < unit * 4) {
        g = unit - 1 - x.truncatingRemainder(dividingBy: unit)
        b = unit - 1
    } else if (x < unit * 5) {
        r = x.truncatingRemainder(dividingBy: unit)
        b = unit - 1
    } else if (x < unit * 6) {
        r = unit - 1
        b = unit - 1 - x.truncatingRemainder(dividingBy: unit)
    }
    
    return UIColor(red:CGFloat(r.divided(by: unit-1)), green:CGFloat(g.divided(by: unit-1)), blue:CGFloat(b.divided(by: unit-1)), alpha: 1.0)
}

extension UIColor {
    var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        self.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
        return hsba
    }
}
