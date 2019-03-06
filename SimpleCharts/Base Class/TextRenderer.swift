//
//  TextRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 06/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation



open class TextRenderer {
  
  var paragraphStyle: NSMutableParagraphStyle
  var font: UIFont
  var foreGroundColor: UIColor
  
  required public init(paragraphStyle: NSMutableParagraphStyle, font: UIFont, foreGroundColor: UIColor) {
    self.paragraphStyle = paragraphStyle
    self.font = font
    self.foreGroundColor = foreGroundColor
  }
  
  
  /// Function for rendering text in the view
  open func renderText(text: String, textFrame: CGRect) {

    let attributes: [NSAttributedString.Key : Any] = [
      .paragraphStyle: paragraphStyle,
      .font: font,
      .foregroundColor: foreGroundColor
    ]
    
    let attributedString = NSAttributedString(string: text, attributes: attributes)
    
    attributedString.draw(in: textFrame)
    
  }
  
  
}
