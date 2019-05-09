//
//  CustomExtensions.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 31/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import CoreGraphics

extension CGContext {
  
  /// This extension is thanks to an article made by (https://www.bignerdranch.com/blog/core-graphics-part-2-contextually-speaking/)
  func protectGState(_ drawStuff: () -> Void) {
    saveGState()
    drawStuff()
    restoreGState()
  }
}

/// This extension is from this tutorial (https://youtu.be/qmXpK1-Ak5U?t=1289)
extension FloatingPoint {
  var degreesToRadians: Self {return self * .pi / 180}
}
