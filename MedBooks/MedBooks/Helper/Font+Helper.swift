//
//  Font+Helper.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import UIKit
import Foundation

extension UILabel {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.adjustFontSize()
    }
    
    func adjustFontSize() {
        if let font = self.font {
            self.font = font.withSize(font.pointSize * _heightRatio)
        }
    }
}

extension UITextField {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.adjustFontSize()
    }
    
    func adjustFontSize() {
        if let font = self.font {
            self.font = font.withSize(font.pointSize * _heightRatio)
        }
    }
}

extension UITextView {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.adjustFontSize()
    }
    
    func adjustFontSize() {
        if let font = self.font {
            self.font = font.withSize(font.pointSize * _heightRatio)
        }
    }
}

extension UIButton {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.adjustFontSize()
    }
    
    func adjustFontSize() {
        if let font = self.titleLabel?.font {
            self.titleLabel?.font = font.withSize(font.pointSize * _heightRatio)
        }
    }
}
