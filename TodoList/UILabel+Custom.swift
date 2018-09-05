//
//  UILabel+Custom.swift
//  TodoList
//
//  Created by Bennett on 2018-09-05.
//  Copyright © 2018 Bennett. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
  func setStrikethrough(text:String, color:UIColor = UIColor.black) {
    let attributedText = NSMutableAttributedString(string: text)
    attributedText.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedText.length))
    self.attributedText = attributedText
    }
  func setNormal(text:String){
    self.attributedText = NSMutableAttributedString(string: text)
  }
}
