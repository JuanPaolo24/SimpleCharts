//
//  PieSliceLayer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 30/04/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation
import QuartzCore

var anim = CABasicAnimation(keyPath: "path")

class PieSliceLayer: CALayer {
  var startAngle: CGFloat = 0.0
  var endAngle: CGFloat = 0.0
  var fillColor: UIColor?
  var strokeWidth: CGFloat = 0.0
  var strokeColor: UIColor?
  
  
  func action(forKey event: String) -> CAAction? {
    if (event == "startAngle") || (event == "endAngle") {
      return makeAnimation(forKey: event)
    }
    
    return super.action(forKey: event)
  }
  
  init(layer: Any) {
    super.init(layer: layer)
    if (layer is PieSliceLayer) {
      let other = layer as? PieSliceLayer
      startAngle = other?.startAngle
      endAngle = other?.endAngle
      fillColor = other?.fillColor
      
      strokeColor = other?.strokeColor
      strokeWidth = other?.strokeWidth
    }
  }
  
  class func needsDisplay(forKey key: String) -> Bool {
    if (key == "startAngle") || (key == "endAngle") {
      return true
    }
    
    return super.needsDisplay(forKey: key)
  }
}



//  Converted to Swift 5 by Swiftify v5.0.39155 - https://objectivec2swift.com/
import QuartzCore

func DEG2RAD(_ angle: Any) -> Double {
  return angle * .pi / 180.0
}


class PieView {
  private var normalizedValues: [AnyHashable] = []
  private var containerLayer: CALayer?
  
  private func updateSlices() {
  }
  
  func doInitialSetup() {
    containerLayer = CALayer()
    if let containerLayer = containerLayer {
      layer.addSublayer(containerLayer)
    }
  }
  
  init(frame: CGRect) {
    super.init(frame: frame)
    doInitialSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    //if super.init(coder: aDecoder)
    doInitialSetup()
  }
  
  convenience init(sliceValues: [Any]?) {
    doInitialSetup()
    self.sliceValues = sliceValues
  }
  
  func setSliceValues(_ sliceValues: [Any]?) {
    self.sliceValues = sliceValues
    
    normalizedValues = []
    if sliceValues != nil {
      
      // total
      var total: CGFloat = 0.0
      for num in sliceValues as? [NSNumber] ?? [] {
        total += CGFloat(num.floatValue)
      }
      
      // normalize
      for num in sliceValues as? [NSNumber] ?? [] {
        normalizedValues.append(NSNumber(value: Float(CGFloat(num.floatValue) / total)))
      }
    }
    
    updateSlices()
  }
}
