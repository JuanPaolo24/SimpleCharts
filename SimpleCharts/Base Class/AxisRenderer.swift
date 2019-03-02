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
  
  /// Returns the height of the current frame
  func frameHeight() -> Double {
    let frameHeight = Double(frame.size.height)
    
    return frameHeight
  }
  
  /// Returns the width of the current frame
  func frameWidth() -> Double {
    let frameWidth = Double(frame.size.width)
    
    return frameWidth
  }
  
  
  /// Base function for drawing Axis labels using the create label helper function
  private func drawAxisLabels(x: Double, y: Double, text: String) {
    let textFrame = CGRect(x: x, y: y, width: 20, height: 40)
    helper.renderText(text: text, textFrame: textFrame)
  }
  
  
  /// Renders the Y axis labels
  func yAxis(context: CGContext, maxValue: Double, padding: Double) {
    let calc = LineGraphCalculation(arrayCount: 0, maxValue: maxValue, initialValue: padding, frameWidth: frameWidth(), frameHeight: frameHeight())
    
    for i in 0...currentFrame.yAxisGridlinesCount {
      let xValue = calc.yAxisLabelxValue()
      let yValue = calc.yAxisLabelyValue(i: i)
      let label = calc.yAxisLabelText(i: i)
      drawAxisLabels(x: xValue, y: yValue, text: label)
    }
  }
  
  
  /// Renders the X axis labels
  func xAxis(context: CGContext, arrayCount: Int, initialValue: Double) {
    let calc = LineGraphCalculation(arrayCount: arrayCount, maxValue: 0, initialValue: initialValue, frameWidth: frameWidth(), frameHeight: frameHeight())
    
    for i in 0...arrayCount {
      let xValue = calc.xAxisLabelxValue(i: i)
      let yValue = calc.xAxisLabelyValue()
      let label = calc.xAxisLabelText(i: i)
      
      drawAxisLabels(x: xValue, y: yValue, text: label)
    }
  }
  
  
  /// Renders the X axis label for the bar graph
  func barGraphxAxis(context: CGContext, arrayCount: Int, initialValue: Double) {
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), initialValue: initialValue, arrayCount: Double(arrayCount))
    for i in 0...arrayCount - 1 {
      let xValue = calc.xVerticalGraphxAxisLabel(i: i)
      print(xValue)
      let yValue = calc.xVerticalGraphyAxisLabel()
      drawAxisLabels(x: xValue, y: yValue, text: String(i + 1))
    }

  }
  

  
  /// Renders the horizontal bar graphs Y axis labels
  func horizontalBarGraphYAxis(context: CGContext, arrayCount: Int, padding: Double) {

    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), initialValue: padding, arrayCount: Double(arrayCount))

    for i in 0...arrayCount - 1 {
      let xValue = calc.horizontalYAxisLabelxPoint()
      let yValue = calc.horizontalYAxisLabelyPoint(i: i)
      drawAxisLabels(x: xValue, y: yValue, text: String(i + 1))
      
      
    }
  }
  
  
  /// Renders the horizontal bar graphs X axis labels
  func horizontalBarGraphXAxis(context: CGContext, maxValue: Double, initialValue: Double) {
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: maxValue, initialValue: initialValue, arrayCount: Double(currentFrame.yAxisGridlinesCount + 1))
    
    for i in 0...currentFrame.yAxisGridlinesCount {
      let xValue = calc.horizontalXAxisLabelxPoint(i: i)
      let yValue = calc.horizontalXAxisLabelyPoint()
      let label = calc.horizontalXAxisText(i: i)

      drawAxisLabels(x: xValue, y: yValue, text: label)
    }
    
  }
  
}
