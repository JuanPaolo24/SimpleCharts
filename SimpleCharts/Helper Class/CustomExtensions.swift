//
//  CustomExtensions.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 31/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import CoreGraphics

extension CGContext{
  
  /// This extension is thanks to an article made by (https://www.bignerdranch.com/blog/core-graphics-part-2-contextually-speaking/)
  func protectGState(_ drawStuff: () -> Void) {
    saveGState()
    drawStuff()
    restoreGState()
  }
}
