//
//  AxisRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 21/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class AxisLabelRenderer: ChartRenderer {

  let customisationSource = ChartData()
  
  /// Base function for drawing Axis labels using the create label helper function
  func drawAxisLabels(x: Double, y: Double, text: String, width: Double, height: Double) {
    let textFrame = CGRect(x: x, y: y, width: width, height: height)
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: 8.0), foreGroundColor: UIColor.black)
    
    textRenderer.renderText(text: text, textFrame: textFrame)
  }
  
  
  /// Renders the Y axis labels
  func drawYAxisLabel(on context: CGContext, using gridlineCount: Double, with axisInverse: Bool) {
    for increment in 0...Int(gridlineCount) {
      let leftLabelPoint = calculate.yAxisLabel(using: increment, andisLeft: true)
      let rightLabelPoint = calculate.yAxisLabel(using: increment, andisLeft: false)
      var label = ""
      if axisInverse == true {
        label = calculate.yAxisLabelText(i: Int(gridlineCount - 1) - increment)
      } else {
        label = calculate.yAxisLabelText(i: increment)
      }
      
      let leftTextFrame = CGRect(x: leftLabelPoint.x, y: leftLabelPoint.y, width: 20, height: 40)
      let rightTextFrame = CGRect(x: rightLabelPoint.x, y: rightLabelPoint.y, width: 20, height: 40)
      
      let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: 8.0), foreGroundColor: UIColor.black)
      textRenderer.renderText(text: label, textFrame: leftTextFrame)
      textRenderer.renderText(text: label, textFrame: rightTextFrame)
    }
  }
  
  
  /// Renders the X axis labels
  func drawXAxisLabel(on context: CGContext, using gridlineCount: Double) {
    for increment in 0...Int(gridlineCount) {
      let bottomLabelPoint = calculate.xAxisLabel(using: increment, andisBottom: true)
      let topLabelPoint = calculate.xAxisLabel(using: increment, andisBottom: false)
      let label = calculate.xAxisLabelText(i: increment)
      
      let bottomTextFrame = CGRect(x: bottomLabelPoint.x, y: bottomLabelPoint.y, width: 20, height: 40)
      let topTextFrame = CGRect(x: topLabelPoint.x, y: topLabelPoint.y, width: 20, height: 40)
      
      let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: 8.0), foreGroundColor: UIColor.black)
      textRenderer.renderText(text: label, textFrame: bottomTextFrame)
      textRenderer.renderText(text: label, textFrame: topTextFrame)
    }
  }
  
  
  /// Renders the X axis label for the bar graph
  func drawbarXAxisLabel(on context: CGContext, using arrayCount: Int) {
    
    for increment in 0...arrayCount - 1 {
      let labelPoint = calculate.barXAxisLabel(using: increment)
      let textFrame = CGRect(x: labelPoint.x, y: labelPoint.y, width: 20, height: 40)
      let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: 8.0), foreGroundColor: UIColor.black)
      textRenderer.renderText(text: String(increment + 1), textFrame: textFrame)
    }
  }
  
  func customiseBarGraphxAxis(context: CGContext, arrayCount: Int, label: [String], offSet: offset) {
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: 0, minValue: 0, arrayCount: Double(arrayCount), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
    
    for i in 0...arrayCount - 1 {
//      let xValue = calc.xVerticalGraphxAxisLabel(i: i)
//      let yValue = calc.xVerticalGraphyAxisLabel()
//      if label.count < arrayCount {
//        var placeholderArray = label
//        placeholderArray.append(contentsOf: Array(repeating: "Placeholder", count: arrayCount - label.count))
//        drawAxisLabels(x: xValue, y: yValue, text: placeholderArray[i], width: 60, height: 40)
//      } else {
//        drawAxisLabels(x: xValue, y: yValue, text: label[i], width: 40, height: 40)
//      }
//
    }
  }
  

  
  /// Renders the horizontal bar graphs Y axis labels
  func horizontalBarGraphYAxis(context: CGContext, arrayCount: Int, offSet: offset) {

    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: 0, minValue: 0, arrayCount: Double(arrayCount), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
    

    for i in 0...arrayCount - 1 {
//      let xValue = calc.horizontalYAxisLabelxPoint()
//      let yValue = calc.horizontalYAxisLabelyPoint(i: i)
//      drawAxisLabels(x: xValue, y: yValue, text: String(i + 1), width: 20, height: 40)
//      
//      
    }
  }
  
  
  /// Renders the horizontal bar graphs X axis labels
  func horizontalBarGraphXAxis(context: CGContext, maxValue: Double, minValue: Double, offSet: offset, gridline: Double) {
    
    let calc = LineGraphCalculation(array: [], arrayCount: Int(gridline + 1), maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: gridline, xAxisGridlineCount: gridline)
    
    
    for i in 0...Int(gridline) {
//      let xValue = calc.xHorizontalAxisLabel(i: i)
//      let yValue = calc.xAxisLabelyValue(isBottom: true)
//      let label = calc.yAxisLabelText(i: i)
//      drawAxisLabels(x: xValue, y: yValue, text: label, width: 20, height: 40)
    }
    
  }
  
}
