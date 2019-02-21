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
  func drawAxisLabels(x: Double, y: Double, text: String) {
    let textFrame = CGRect(x: x, y: y, width: 20, height: 20)
    helper.createLabel(text: text, textFrame: textFrame)
  }
  
  
  /// Renders the Y axis labels
  func yAxis(context: CGContext, maxValue: Double) {
    let frameScale = (Double(frame.size.height) - StaticVariables.distanceFromBottom) / Double(StaticVariables.yAxisGridlinesCount)
    let actualDataScale = Int(maxValue / 6)
    
    for i in 0...StaticVariables.yAxisGridlinesCount {
      let valueIncrement = Double(i)
      let actualValue = frameScale * valueIncrement
      drawAxisLabels(x: 0, y: Double(frame.size.height) - 60 - actualValue, text: String(i * actualDataScale))
    }
  }
  
  
  /// Renders the X axis labels
  func xAxis(context: CGContext, arrayCount: Int) {
    let pointIncrement = (Double(frame.size.width) - StaticVariables.leftAndRightSidePadding) / Double(arrayCount)
    
    for i in 0...arrayCount - 1 {
      let xValue = helper.calculatexValue(pointIncrement: pointIncrement, distanceIncrement: i, sideMargin: StaticVariables.sidePadding)
      drawAxisLabels(x: xValue - 5, y: Double(frame.size.height) - 55, text: String(i + 1))
    }
  }
  
  
  func horizontalBarGraphYAxis(context: CGContext, arrayCount: Int) {
    
    for i in 0...arrayCount {
      let frameScale = (Double(frame.size.height) - StaticVariables.distanceFromBottom) / Double(arrayCount)
      
      let valueIncrement = Double(i)
      let actualValue = frameScale * valueIncrement
      drawAxisLabels(x: 10, y: Double(frame.size.height) - 60 - actualValue, text: String(arrayCount - (i - 1)))
    }
    
  }
  
  func horizontalBarGraphXAxis(context: CGContext, maxValue: Double) {
    let pointIncrement = (Double(frame.size.width) - StaticVariables.leftAndRightSidePadding) / Double(StaticVariables.yAxisGridlinesCount)
    let actualDataScale = Int(maxValue / 6)
    
    for i in 0...StaticVariables.yAxisGridlinesCount {
      let xValue = helper.calculatexValue(pointIncrement: pointIncrement, distanceIncrement: i, sideMargin: StaticVariables.leftAndRightSidePadding)
      print(xValue)
      drawAxisLabels(x: xValue - 5, y: Double(frame.size.height) - 55, text: String(i * actualDataScale))
    }
    
  }
  
}
