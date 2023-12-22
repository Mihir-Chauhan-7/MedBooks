//
//  Ratio+Helper.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import UIKit
import Foundation

/*---------------------------------------------------
 Screen Size
 ---------------------------------------------------*/
let _screenBounds       = UIScreen.main.bounds
let _screenSize         = UIScreen.main.bounds.size
var _designScreenSize   = CGSize(width: 375, height: 667)

/*---------------------------------------------------
 Ratio
 ---------------------------------------------------*/
let _heightRatio: CGFloat = {
    let ratio = _screenSize.height / _designScreenSize.height
    return ratio
}()

let _widthRatio: CGFloat = {
    let ratio = _screenSize.width / _designScreenSize.width
    return ratio
}()
