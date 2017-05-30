//
//  KeyPayload.swift
//  FlickrShowcase
//
//  Created by ShengHua Wu on 30/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import UIKit

// MARK: - Keyboard Payload
struct KeyboardPayload {
    let beginFrame: CGRect
    let endFrame: CGRect
    let curve: UIViewAnimationCurve
    let duration: TimeInterval
    let isLocal: Bool
}

extension KeyboardPayload {
    init(note: Notification) {
        let userInfo = note.userInfo
        beginFrame = userInfo?[UIKeyboardFrameBeginUserInfoKey] as! CGRect
        endFrame = userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        curve = UIViewAnimationCurve(rawValue: userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! Int)!
        duration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        isLocal = userInfo?[UIKeyboardIsLocalUserInfoKey] as! Bool
    }
}

// MARK: - View Controller Extension
extension UIViewController {
    static let keyboardWillShow = NotificationDescriptor(name: Notification.Name.UIKeyboardWillShow, convert: KeyboardPayload.init)
    static let keyboardWillHide = NotificationDescriptor(name: Notification.Name.UIKeyboardWillHide, convert: KeyboardPayload.init)
}
