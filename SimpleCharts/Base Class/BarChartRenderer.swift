//
//  BarChartRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 19/04/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

open class BarChartRenderer: ChartRenderer {
  
  var customisationSource = BarChartData()
  let helper = HelperFunctions()

  /// Renders a horizontal bar graph
  func addHorizontalBarGraph(to context: CGContext, from array: [Double], with dataSetIncrement: Double, and dataSetCount: Double) {
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: customisationSource.setTextLabelFont), foreGroundColor: customisationSource.setTextLabelColour)
    
    for (increment, value) in array.enumerated() {
      let yValue = calculate.yHorizontalValue(using: increment, with: dataSetIncrement, and: dataSetCount)
      let xValue = calculate.xHorizontalValue()
      let width = calculate.horizontalWidth(using: value)
      let height = calculate.horizontalHeight(using: dataSetCount)
      let xFrame = calculate.xHorizontalTextFrame(using: value)
      let yFrame = calculate.yHorizontalTextFrame(using: increment, with: dataSetIncrement, and: dataSetCount)
      
      context.protectGState {
        context.setFillColor(customisationSource.setBarGraphFillColour)
        context.setStrokeColor(customisationSource.setBarGraphStrokeColour)
        context.setLineWidth(customisationSource.setBarGraphLineWidth)
        context.addRect(CGRect(x: xValue, y: yValue, width: width, height: height))
        context.drawPath(using: .fillStroke)
      }
      textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: xFrame, y: yFrame, width: 40, height: 20))
    }
    
  }
  
  
  // Renders a vertical bar graph with support for multiple data sets
  func addVerticalBarGraph(to context: CGContext, from array: [Double], with dataSetIncrement: Double, and dataSetCount: Double) {
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: customisationSource.setTextLabelFont), foreGroundColor: customisationSource.setTextLabelColour)
    
    for (increment, value) in array.enumerated() {
      
      let width = calculate.verticalWidth(using: dataSetCount)
      let xValue = calculate.xVerticalValue(using: increment, with: dataSetIncrement, and: dataSetCount)
      let yValue = calculate.yVerticalValue(using: value)
      let height = calculate.verticalHeight(using: value)
      let xFrame = calculate.xVerticalTextFrame(using: increment, with: dataSetIncrement, and: dataSetCount)
      let yFrame = calculate.yVerticalTextFrame(using: value)
      
      context.protectGState {
        context.setFillColor(customisationSource.setBarGraphFillColour)
        context.setStrokeColor(customisationSource.setBarGraphStrokeColour)
        context.setLineWidth(customisationSource.setBarGraphLineWidth)
        context.addRect(CGRect(x: xValue, y: yValue, width: width, height: height))
        context.drawPath(using: .fillStroke)
      }
      
      if customisationSource.enableDataPointLabel == true {
        textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: xFrame, y: yFrame, width: 40, height: 20))
      }
    }
  }
  
  func highlightHorizontalValues(in context: CGContext, using array: [[Double]], and touchPoint: CGPoint, with maxValue: Double,  _ minValue: Double,  _ arrayCount: Double,  _ offSet: offset) {
    var calc = GraphCalculation()
    
    var highlightValueArray: [CGRect] = []
    
    for i in 0...(array.count - 1) {
      for (increment, value) in array[i].enumerated() {
        calc = GraphCalculation(arrayCount: array[i].count, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet)

        let yValue = calc.yHorizontalValue(using: increment, with: Double(i), and: arrayCount)
        let xValue = calc.xHorizontalValue()
        let width = calc.horizontalWidth(using: value)
        let height = calc.horizontalHeight(using: arrayCount)
        highlightValueArray.append(CGRect(x: xValue, y: yValue, width: width, height: height))
      }
    }
    
    let sortedXPoint = helper.combineCGRectHorizontal(Array: highlightValueArray)
    let newXPoint = helper.returnClosestHorizontal(from: sortedXPoint, using: touchPoint)
    context.protectGState {
      context.setFillColor(UIColor(red:0.24, green:0.24, blue:0.24, alpha:0.5).cgColor)
      context.setStrokeColor(UIColor(red:0.24, green:0.24, blue:0.24, alpha:0.5).cgColor)
      context.setLineWidth(1.0)
      context.addRect(newXPoint)
      context.drawPath(using: .fillStroke)
    }
  }
  
  
  func highlightValues(in context: CGContext, using array: [[Double]], and touchPoint: CGPoint, with maxValue: Double,  _ minValue: Double, _ arrayCount: Double,  _ offSet: offset) {
    var calc = GraphCalculation()
    var highlightValueArray: [CGRect] = []
    var width = 0.0
    var height = 0.0
    var xValue = 0.0
    
    for i in 0...(array.count - 1) {
      for (increment, value) in array[i].enumerated() {
        calc = GraphCalculation(arrayCount: array[i].count, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet)
        
        width = calc.verticalWidth(using: arrayCount)
        xValue = calc.xVerticalValue(using: increment, with: Double(i), and: arrayCount)
        let yValue = calc.yVerticalValue(using: value)
        
        height = calc.verticalHeight(using: value)
        highlightValueArray.append(CGRect(x: xValue, y: yValue, width: width, height: height))
      }
    }
    
    let sortedXPoint = helper.combineCGRect(Array: highlightValueArray)
    let newXPoint = helper.returnClosestRect(from: sortedXPoint, using: touchPoint)
    context.protectGState {
      context.setFillColor(UIColor(red:0.24, green:0.24, blue:0.24, alpha:0.5).cgColor)
      context.setStrokeColor(UIColor(red:0.24, green:0.24, blue:0.24, alpha:0.5).cgColor)
      context.setLineWidth(1.0)
      context.addRect(newXPoint)
      context.drawPath(using: .fillStroke)
    }
  }

}
