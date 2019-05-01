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

  /// Renders a special X axis gridline for the bar chart
  func drawBarXAxisGridline(on context: CGContext, using arrayCount: Int) {
    for increment in 0...arrayCount - 1 {
      let startPoint = calculate.barXGridlinePoint(using: increment, for: .start)
      let endPoint = calculate.barXGridlinePoint(using: increment, for: .end)
      
      if enableYGridVisibility == true {
        drawGridLines(context: context, start: startPoint, end: endPoint)
      }
    }
  }
  
  
  /// Renders a horizontal bar graph
  func addHorizontalBarGraph(to context: CGContext, from array: [Double], with dataSetIncrement: Double, and dataSetCount: Double) {
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: customisationSource.setTextLabelFont), foreGroundColor: customisationSource.setTextLabelColour)
    
    for (increment, value) in array.enumerated() {
      let yValue = calculate.yHorizontalValue(i: increment, dataSetCount: dataSetIncrement, count: dataSetCount)
      let xValue = calculate.xHorizontalValue()
      let width = calculate.horizontalWidth(value: value)
      let height = calculate.horizontalHeight(count: dataSetCount)
      let xFrame = calculate.xHorizontalTextFrame(value: value)
      let yFrame = calculate.yHorizontalTextFrame(i: increment, dataSetCount: dataSetIncrement, count: dataSetCount)
      
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
      
      let width = calculate.verticalWidth(count: dataSetCount)
      let xValue = calculate.xVerticalValue(i: increment, dataSetCount: dataSetIncrement, count: dataSetCount)
      let yValue = calculate.yVerticalValue(value: value)
      let height = calculate.verticalHeight(value: value)
      let xFrame = calculate.xVerticalTextFrame(i: increment, dataSetCount: dataSetIncrement, count: dataSetCount)
      let yFrame = calculate.yVerticalTextFrame(value: value)
      
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
  
  
  /// Y Gridlines used by the horizontal bar graph
  func drawHorizontalYGridlines(on context: CGContext, using arrayCount: Int) {
    for increment in 0...arrayCount {
      let yStartPoint = calculate.yHorizontalGridline(using: increment, for: .start)
      let yEndPoint = calculate.yHorizontalGridline(using: increment, for: .end)
      drawGridLines(context: context, start: yStartPoint, end: yEndPoint)
    }
  }
  
  /// X Gridlines used by the horizontal bar graph
  func drawHorizontalXGridlines(on context: CGContext, using gridline: Double) {
    for increment in 0...Int(gridline) {
      let startPoint = calculate.xHorizontalGridline(using: increment, for: .start )
      let endPoint = calculate.xHorizontalGridline(using: increment, for: .end)
      drawGridLines(context: context, start: startPoint, end: endPoint)
    }
  }

}
