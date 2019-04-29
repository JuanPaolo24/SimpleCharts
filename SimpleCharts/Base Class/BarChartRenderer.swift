//
//  BarChartRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 19/04/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

open class BarChartRenderer: ChartRenderer {
  
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  /// Base function for drawing rectangles
  func drawRectangle(context: CGContext, x: Double, y: Double, width: Double, height: Double, source: BarChartData) {
    let rectangle = CGRect(x: x, y: y, width: width, height: height)
    context.protectGState {
      context.setFillColor(source.setBarGraphFillColour)
      context.setStrokeColor(source.setBarGraphStrokeColour)
      context.setLineWidth(source.setBarGraphLineWidth)
      context.addRect(rectangle)
      context.drawPath(using: .fillStroke)
    }
  }
  

  /// Renders a special X axis gridline for the bar chart
  func barxAxisGridlines(context: CGContext, arrayCount: Int, offSet: offset) {
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: 0, minValue: 0, arrayCount: Double(arrayCount), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
    
    for i in 0...arrayCount - 1 {
      let startPoint = calc.xGridlineStartCalculation(distanceIncrement: i)
      let endPoint = calc.xGridlineEndCalculation(distanceIncrement: i)
      
      if enableXGridline == true {
        drawGridLines(context: context, start: startPoint, end: endPoint)
      }
    }
  }
  
  
  /// Renders a horizontal bar graph
  func drawHorizontalBarGraph(context: CGContext, array: [Double], maxValue: Double, minValue: Double, data: BarChartData, overallCount: Double, arrayCount: Double, offSet: offset) {
    
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: maxValue, minValue: minValue, arrayCount: Double(array.count), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: data.setTextLabelFont), foreGroundColor: data.setTextLabelColour)
    
    for (i, value) in array.enumerated() {
      let yValue = calc.yHorizontalValue(i: i, dataSetCount: overallCount, count: arrayCount)
      let xValue = calc.xHorizontalValue()
      let width = calc.horizontalWidth(value: value)
      let height = calc.horizontalHeight(count: arrayCount)
      let xFrame = calc.xHorizontalTextFrame(value: value)
      let yFrame = calc.yHorizontalTextFrame(i: i, dataSetCount: overallCount, count: arrayCount)
      
      drawRectangle(context: context, x: xValue, y: yValue, width: width, height: height, source: data)
      textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: xFrame, y: yFrame, width: 40, height: 20))
    }
    
  }
  
  
  // Renders a vertical bar graph with support for multiple data sets
  func drawVerticalBarGraph(context: CGContext, array: [Double], maxValue: Double, minValue: Double, data: BarChartData, overallCount: Double, arrayCount: Double, offSet: offset) {
    
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: maxValue, minValue: minValue, arrayCount: Double(array.count), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: data.setTextLabelFont), foreGroundColor: data.setTextLabelColour)
    
    for (i, value) in array.enumerated() {
      
      let width = calc.verticalWidth(count: arrayCount)
      let xValue = calc.xVerticalValue(i: i, dataSetCount: overallCount, count: arrayCount)
      let yValue = calc.yVerticalValue(value: value)
      let height = calc.verticalHeight(value: value)
      let xFrame = calc.xVerticalTextFrame(i: i, dataSetCount: overallCount, count: arrayCount)
      let yFrame = calc.yVerticalTextFrame(value: value)
      
      drawRectangle(context: context, x: xValue, y: yValue, width: width, height: height, source: data)
      if data.enableDataPointLabel == true {
        textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: xFrame, y: yFrame, width: 40, height: 20))
      }
    }
  }
  
  
  /// Y Gridlines used by the horizontal bar graph
  func horizontalBarGraphYGridlines(context: CGContext, arrayCount: Int, offSet: offset) {
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: 0, minValue: 0, arrayCount: Double(arrayCount), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
    
    for i in 0...arrayCount {
      let yStartPoint = calc.yHorizontalGridline(i: i, destination: position.start)
      let yEndPoint = calc.yHorizontalGridline(i: i, destination: position.end)
      drawGridLines(context: context, start: yStartPoint, end: yEndPoint)
    }
  }
  
  /// X Gridlines used by the horizontal bar graph
  func horizontalBarGraphXGridlines(context: CGContext, offSet: offset, gridline: Double) {
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: 0, minValue: 0, arrayCount: gridline, yAxisGridlineCount: 0, xAxisGridlineCount: gridline, offSet: offSet)
    
    for i in 0...Int(gridline) {
      let startPoint = calc.xHorizontalGridline(i: i, destination: position.start)
      let endPoint = calc.xHorizontalGridline(i: i, destination: position.end)
      
      drawGridLines(context: context, start: startPoint, end: endPoint)
    }
  }
  
}
