//
//  AxisRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 21/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class AxisRenderer: UIView {
  
  
  let helper = RendererHelper()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  /// Base function for drawing Axis labels using the create label helper function
  private func drawAxisLabels(x: Double, y: Double, text: String) {
    let textFrame = CGRect(x: x, y: y, width: 20, height: 40)
    helper.renderText(text: text, textFrame: textFrame)
  }
  
  
  /// Renders the Y axis labels
  func yAxis(context: CGContext, maxValue: Double, padding: Double) {
    let frameScale = (Double(frame.size.height) - currentFrame.distanceFromBottom) / Double(currentFrame.yAxisGridlinesCount)
    let actualDataScale = Int(maxValue / 6)
    
    for i in 0...currentFrame.yAxisGridlinesCount {
      let valueIncrement = Double(i)
      let actualValue = frameScale * valueIncrement
      drawAxisLabels(x: padding - 10, y: Double(frame.size.height) - 60 - actualValue, text: String(i * actualDataScale))
    }
  }
  
  
  /// Renders the X axis labels
  func xAxis(context: CGContext, arrayCount: Int, initialValue: Double) {
    for i in 0...arrayCount - 1 {
      let xValue = helper.calculatexValue(frameWidth: Double(frame.size.width), arrayCount: Double(arrayCount), distanceIncrement: i, initialValue: initialValue)
      drawAxisLabels(x: xValue - 5, y: Double(frame.size.height) - 55, text: String(i + 1))
    }
  }
  
  
  /// Renders the horizontal bar graphs Y axis labels
  func horizontalBarGraphYAxis(context: CGContext, arrayCount: Int, padding: Double) {
    
    for i in 0...arrayCount {
      let frameScale = (Double(frame.size.height) - currentFrame.distanceFromBottom) / Double(arrayCount)
      
      let valueIncrement = Double(i)
      let actualValue = frameScale * valueIncrement
      drawAxisLabels(x: padding - 10, y: Double(frame.size.height) - 60 - actualValue, text: String(arrayCount - (i - 1)))
    }
    
  }
  
  /// Renders the horizontal bar graphs X axis labels
  func horizontalBarGraphXAxis(context: CGContext, maxValue: Double, initialValue: Double) {
    let actualDataScale = Int(maxValue / 6)
    
    for i in 0...currentFrame.yAxisGridlinesCount {
      let xValue = helper.calculatexValue(frameWidth: Double(frame.size.width), arrayCount: Double(currentFrame.yAxisGridlinesCount + 1), distanceIncrement: i, initialValue: initialValue)
      
      
      drawAxisLabels(x: xValue, y: Double(frame.size.height) - 55, text: String(i * actualDataScale))
    }
    
  }
  
}
