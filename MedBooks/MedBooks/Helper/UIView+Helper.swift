//
//  UIView+Helper.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import Foundation
import UIKit

extension UIView {
    func addTapGesture(tapNumber: Int = 1, target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}


