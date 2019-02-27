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
    var scale = 0
   
    if arrayCount < 6 {
      scale = arrayCount / (arrayCount - 1)
    } else {
      scale = arrayCount / 6
    }

    for i in 0...arrayCount {
      let xValue = helper.calculatexValueSpace(frameWidth: Double(frame.size.width), arrayCount: Double(arrayCount), distanceIncrement: i, initialValue: initialValue)
      drawAxisLabels(x: xValue, y: Double(frame.size.height) - 55, text: String(scale * i))
    }
  }
  
  /// Renders the X axis label for the bar graph
  func barGraphxAxis(context: CGContext, arrayCount: Int, initialValue: Double) {
    let initial = initialValue + 5
    for i in 0...arrayCount - 1 {
      let xValue = (Double(frame.size.width - 62) - (initialValue * 2)) / Double(arrayCount - 1)
      drawAxisLabels(x: initial + (Double(i) * xValue), y: Double(frame.size.height) - 55, text: String(i + 1))
    }
    
  }
  
  
  
  /// Renders the horizontal bar graphs Y axis labels
  func horizontalBarGraphYAxis(context: CGContext, arrayCount: Int, padding: Double) {
    var xValue = 0.0
    var pad = 0.0
    
    //Landscape requires a different calculation
    if padding == 70 {
      xValue = ((Double(frame.size.height) - 52) - (padding / 2)) / Double(arrayCount - 1)
      pad = 60
    } else {
      xValue = ((Double(frame.size.height) - 62) - (padding * 2)) / Double(arrayCount - 1)
    }
    
    for i in 0...arrayCount - 1 {
      drawAxisLabels(x: padding - 20, y: (padding - pad) + (xValue * Double(i)), text: String(i + 1))
    }
  }
  
  
  /// Renders the horizontal bar graphs X axis labels
  func horizontalBarGraphXAxis(context: CGContext, maxValue: Double, initialValue: Double) {
    let actualDataScale = Int(maxValue / 6)
    
    for i in 0...currentFrame.yAxisGridlinesCount {
      let xValue = helper.calculatexValueIncrement(frameWidth: Double(frame.size.width), arrayCount: Double(currentFrame.yAxisGridlinesCount + 1), distanceIncrement: i, initialValue: initialValue)
      
      
      drawAxisLabels(x: xValue, y: Double(frame.size.height) - 55, text: String(i * actualDataScale))
    }
    
  }
  
}
