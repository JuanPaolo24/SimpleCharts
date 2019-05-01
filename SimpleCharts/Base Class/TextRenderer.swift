//
//  TextRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 06/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

open class TextRenderer {
  
  var font: UIFont
  var foreGroundColor: UIColor
  var backGroundColor: UIColor
  
  required public init(font: UIFont, foreGroundColor: UIColor) {
    self.font = font
    self.foreGroundColor = foreGroundColor
    self.backGroundColor = UIColor.clear
  }
  
  required public init(font: UIFont, foreGroundColor: UIColor, backGroundColor: UIColor) {
    self.font = font
    self.foreGroundColor = foreGroundColor
    self.backGroundColor = backGroundColor
  }
  
  
  /// Function for rendering text in the view
  open func renderText(text: String, textFrame: CGRect) {

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    
    let attributes: [NSAttributedString.Key : Any] = [
      .paragraphStyle: paragraphStyle,
      .font: font,
      .foregroundColor: foreGroundColor,
      .backgroundColor: backGroundColor
    ]
    
    let attributedString = NSAttributedString(string: text, attributes: attributes)
    
    attributedString.draw(in: textFrame)
    
  }
  
  
}
