//
//  AxisRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 21/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class AxisRenderer: UIView {
  
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
  func drawAxisLabels(x: Double, y: Double, text: String, width: Double, height: Double) {
    let textFrame = CGRect(x: x, y: y, width: width, height: height)
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: 8.0), foreGroundColor: UIColor.black)
    
    textRenderer.renderText(text: text, textFrame: textFrame)
  }
  
  
  /// Renders the Y axis labels
  func yAxis(context: CGContext, maxValue: Double, minValue: Double, axisInverse: Bool, offSet: offset, gridlineCount: Double) {
    
    let calc = LineGraphCalculation(array: [], arrayCount: 0, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: gridlineCount, xAxisGridlineCount: 0)
    
    for i in 0...Int(gridlineCount) {
      let xValue = calc.yAxisLabelxValue(isLeft: true)
      let yValue = calc.yAxisLabelyValue(i: i)
      var label = ""
      let xValue2 = calc.yAxisLabelxValue(isLeft: false)
      if axisInverse == true {
        label = calc.yAxisLabelText(i: Int(gridlineCount - 1) - i)
      } else {
        label = calc.yAxisLabelText(i: i)
      }
      
      drawAxisLabels(x: xValue, y: yValue, text: label, width: 20, height: 40)
      drawAxisLabels(x: xValue2, y: yValue, text: label, width: 20, height: 40)
    }
  }
  
  
  /// Renders the X axis labels
  func xAxis(context: CGContext, arrayCount: Int, offSet: offset, gridlineCount: Double) {
    let calc = LineGraphCalculation(array: [], arrayCount: arrayCount, maxValue: 0, minValue: 0, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: 0, xAxisGridlineCount: gridlineCount)
    for i in 0...Int(gridlineCount) {
      let xValue = calc.xAxisLabelxValue(i: i)
      let yValue = calc.xAxisLabelyValue(isBottom: true)
      let label = calc.xAxisLabelText(i: i)
      let yValue2 = calc.xAxisLabelyValue(isBottom: false)
      
      drawAxisLabels(x: xValue, y: yValue, text: label, width: 20, height: 40)
      drawAxisLabels(x: xValue, y: yValue2, text: label, width: 20, height: 40)
    }
  }
  
  
  /// Renders the X axis label for the bar graph
  func barGraphxAxis(context: CGContext, arrayCount: Int, offSet: offset) {
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: 0, minValue: 0, arrayCount: Double(arrayCount), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
    
    for i in 0...arrayCount - 1 {
      let xValue = calc.xVerticalGraphxAxisLabel(i: i)
      let yValue = calc.xVerticalGraphyAxisLabel()
      drawAxisLabels(x: xValue, y: yValue, text: String(i + 1), width: 20, height: 40)
    }
  }
  
  func customiseBarGraphxAxis(context: CGContext, arrayCount: Int, label: [String], offSet: offset) {
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: 0, minValue: 0, arrayCount: Double(arrayCount), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
    
    for i in 0...arrayCount - 1 {
      let xValue = calc.xVerticalGraphxAxisLabel(i: i)
      let yValue = calc.xVerticalGraphyAxisLabel()
      if label.count < arrayCount {
        var placeholderArray = label
        placeholderArray.append(contentsOf: Array(repeating: "Placeholder", count: arrayCount - label.count))
        drawAxisLabels(x: xValue, y: yValue, text: placeholderArray[i], width: 60, height: 40)
      } else {
        drawAxisLabels(x: xValue, y: yValue, text: label[i], width: 40, height: 40)
      }
      
    }
  }
  

  
  /// Renders the horizontal bar graphs Y axis labels
  func horizontalBarGraphYAxis(context: CGContext, arrayCount: Int, offSet: offset) {

    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: 0, minValue: 0, arrayCount: Double(arrayCount), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
    

    for i in 0...arrayCount - 1 {
      let xValue = calc.horizontalYAxisLabelxPoint()
      let yValue = calc.horizontalYAxisLabelyPoint(i: i)
      drawAxisLabels(x: xValue, y: yValue, text: String(i + 1), width: 20, height: 40)
      
      
    }
  }
  
  
  /// Renders the horizontal bar graphs X axis labels
  func horizontalBarGraphXAxis(context: CGContext, maxValue: Double, minValue: Double, offSet: offset, gridline: Double) {
    
    let calc = LineGraphCalculation(array: [], arrayCount: Int(gridline + 1), maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: gridline, xAxisGridlineCount: gridline)
    
    
    for i in 0...Int(gridline) {
      let xValue = calc.xHorizontalAxisLabel(i: i)
      let yValue = calc.xAxisLabelyValue(isBottom: true)
      let label = calc.yAxisLabelText(i: i)
      drawAxisLabels(x: xValue, y: yValue, text: label, width: 20, height: 40)
    }
    
  }
  
}
