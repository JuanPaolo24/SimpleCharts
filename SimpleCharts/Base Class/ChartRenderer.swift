//
//  ChartRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 07/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation
import CoreGraphics

extension FloatingPoint {
  var degreesToRadians: Self {return self * .pi / 180}
}

open class ChartRenderer: UIView {
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  //General
  /// Enable the Y gridline on the chart
  open var enableYGridline = true
  
  /// Enable the X gridline on the chart
  open var enableXGridline = true
  
  /// Set the Y Axis base colour
  open var setYAxisBaseColour = UIColor.black.cgColor
  
  /// Set the X Axis base colour
  open var setXAxisBaseColour = UIColor.black.cgColor
  
  /// Set Gridline colour
  open var setGridlineColour = UIColor.black.cgColor
  
  /// Set Gridline Line Width (Default = 0.5)
  open var setGridlineWidth = CGFloat(0.5)
  
  /// Set the Gridline stroke design (Default = False)
  open var enableGridLineDash = true
  
  
  
  //Bar Chart
  /// Set Bar Graph inside colour (Default = Black)
  open var setBarGraphFillColour = UIColor.black.cgColor
  
  /// Set Bar Graph outline colour (Default = Black)
  open var setBarGraphStrokeColour = UIColor.black.cgColor
  
  /// Set Bar Graph Line Width (Default = 1.0)
  open var setBarGraphLineWidth = CGFloat(1.0)
  
  
  
  //Line Chart
  /// Enable the circle points
  open var enableCirclePoint = true
  
  /// Enable the line 
  open var enableLine = true
  
  /// Set Circle Point (Line Graph) colour
  open var setCirclePointColour = UIColor.black.cgColor
  
  /// Set Line Point (Line Graph) colour
  open var setLinePointColour = UIColor.black.cgColor
  
  /// Set Circle Point Radius (Default = 3)
  open var setCirclePointRadius = CGFloat(3.0)
  
  /// Set Line Point Width (Default = 1)
  open var setLineWidth = CGFloat(1.0)
  
  
  /// An instance of the RendererHelper class for access to helper functions
  private var helper = RendererHelper()
  
  /// Returns the height of the current frame
  private func frameHeight() -> Double {
    let frameHeight = Double(frame.size.height)
    
    return frameHeight
  }
  
  /// Returns the width of the current frame
  private func frameWidth() -> Double {
    let frameWidth = Double(frame.size.width)
    
    return frameWidth
  }
  
  /// Base function for drawing axis bases
  private func drawAxisBase(context: CGContext, start: CGPoint, end: CGPoint, strokeColour: CGColor, width: CGFloat) {
    let axisBase = CGMutablePath()
    axisBase.move(to: start)
    axisBase.addLine(to: end)
    context.addPath(axisBase)
    context.setLineWidth(width)
    context.setStrokeColor(strokeColour)
    context.strokePath()
  }
  
  
  /// Base function for drawing gridlines using the start and end points
  private func drawGridLines(context: CGContext, start: CGPoint, end: CGPoint) {
    
    let gridLine = CGMutablePath()
    gridLine.move(to: start)
    gridLine.addLine(to: end)
    context.addPath(gridLine)
    context.setStrokeColor(setGridlineColour)
    context.strokePath()
    context.setLineWidth(setGridlineWidth)
    
    if enableGridLineDash == true {
      context.setLineDash(phase: 0, lengths: [1])
    }
    
  }
  
  /// Base function for drawing Axis labels using the create label helper function
  private func drawAxisLabels(x: Double, y: Double, text: String) {
    let textFrame = CGRect(x: x, y: y, width: 20, height: 20)
    helper.createLabel(text: text, textFrame: textFrame)
  }
  
  
  /// Base function for drawing circle on the destination coordinates (CGPoint)
  private func drawCirclePoints(context: CGContext, destination: CGPoint) {
    context.addArc(center: destination, radius: setCirclePointRadius, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
    context.setFillColor(setCirclePointColour)
    context.fillPath()
    
  }
  
  /// Base function for drawing lines from the a start point(Mutable Path) to a destination point (CGPoint)
  private func drawLines(context: CGContext, startingPoint: CGMutablePath, destinationPoint: CGPoint) {
    startingPoint.addLine(to: destinationPoint)
    context.addPath(startingPoint)
    context.setStrokeColor(setLinePointColour)
    context.strokePath()
    context.setLineWidth(setLineWidth)
  }
  
  // Base function for drawing single line graphs. Requires context, the array to be plotted and the max value of the whole data set
  private func drawLineGraph(context: CGContext, array: [Double], maxValue: Double) {
    let connection = CGMutablePath()
    let yAxisPadding = frameHeight() - StaticVariables.extraSidePadding
    let arrayCount = Double(array.count)
    let pointIncrement = (frameWidth() - StaticVariables.leftAndRightSidePadding) / arrayCount
    
    if let firstValue = array.first {
      let yValue = (yAxisPadding / maxValue) * firstValue
      connection.move(to: CGPoint(x: helper.calculatexValue(pointIncrement: pointIncrement, distanceIncrement: 0, sideMargin: 41.0), y: yAxisPadding - yValue))
    }
  
    for (i, value) in array.enumerated() {
      let xValue = helper.calculatexValue(pointIncrement: pointIncrement, distanceIncrement: i, sideMargin: 41.0)
      let yValuePosition = (yAxisPadding / maxValue) * value
      let yValue = yAxisPadding - yValuePosition
      let destinationPoint = CGPoint(x: xValue, y: yValue)
      
      if enableCirclePoint == true {
        drawCirclePoints(context: context, destination: destinationPoint)
      }
      if enableLine == true {
        drawLines(context: context, startingPoint: connection, destinationPoint: destinationPoint)
      }
    }
  }
  
  
  
  
  /// A function that draws the Y axis line used by Line and Bar Graph
  func yAxisBase(context: CGContext) {
    let yAxisPadding = frameHeight() - StaticVariables.sidePadding
    let startPoint = CGPoint(x: 30, y: 10)
    let endPoint = CGPoint(x: 30, y: yAxisPadding)
    
    drawAxisBase(context: context, start: startPoint, end: endPoint, strokeColour: setYAxisBaseColour, width: 3.0)
  }
  
  /// A function that draw the X axis line used by Line and Bar Graph
  
  func xAxisBase(context: CGContext) {
    
    let yAxisPadding = frameHeight() - StaticVariables.sidePadding
    let xAxisPadding = frameWidth() - StaticVariables.leftAndRightSidePadding
    let startPoint = CGPoint(x: 30, y: yAxisPadding)
    let endPoint = CGPoint(x: xAxisPadding, y: yAxisPadding)
    
    drawAxisBase(context: context, start: startPoint, end: endPoint, strokeColour: setXAxisBaseColour, width: 3.0)
  }
  

  
/// Renders the Y axis gridline and axis labels
  func yAxis(context: CGContext, maxValue: Double) {
    let frameScale = (frameHeight() - StaticVariables.extraSidePadding) / Double(StaticVariables.yAxisGridlinesCount)
    let yAxisPadding = frameHeight() - StaticVariables.sidePadding
    let xAxisPadding = frameWidth() - StaticVariables.leftAndRightSidePadding
    let actualDataScale = Int(maxValue / 6)
    
    for i in 0...StaticVariables.yAxisGridlinesCount {
      let valueIncrement = Double(i)
      let actualValue = frameScale * valueIncrement
      
      let startPoint = CGPoint(x: 30, y: yAxisPadding - actualValue)
      let endPoint = CGPoint(x: xAxisPadding, y: yAxisPadding - actualValue)
      
      if enableYGridline == true {
        drawGridLines(context: context, start: startPoint, end: endPoint)
      }

      drawAxisLabels(x: 0, y: frameHeight() - 36 - actualValue, text: String(i * actualDataScale))
    }
  }
  
  
  /// Renders the X axis gridline and axis labels
  func xAxis(context: CGContext, arrayCount: Int) {
    let yAxisPadding = frameHeight() - StaticVariables.sidePadding
    let pointIncrement = (frameWidth() - StaticVariables.leftAndRightSidePadding) / Double(arrayCount)
    
    for i in 0...arrayCount - 1 {
      
      let xValue = helper.calculatexValue(pointIncrement: pointIncrement, distanceIncrement: i, sideMargin: StaticVariables.extraSidePadding)
      
      let startPoint = CGPoint(x: xValue, y: 10)
      let endPoint = CGPoint(x: xValue, y: yAxisPadding)
      
      if enableXGridline == true {
        drawGridLines(context: context, start: startPoint, end: endPoint)
      }
      drawAxisLabels(x: xValue - 10, y: frameHeight() - 28, text: String(i + 1))
      
    }
  }
  
  /// Renders a line graph
  func lineGraph(context: CGContext, array: [[Double]]) {
    let max = helper.processMultipleArrays(array: array)
    
    for i in array {
      drawLineGraph(context: context, array: i, maxValue: max)
    }
    
  }
  
  
  /// Renders a vertical bar graph
  func renderVerticalBarGraph(context: CGContext, array: [Double]) {
    var maxValue = 0.0
    let yAxisPadding = (frameHeight() - StaticVariables.extraSidePadding)
    
    if let max = array.max() {
      maxValue = max + 41
    }
    
    for (i, value) in array.enumerated() {
      
      let xValue = (frameWidth() - 93) / Double(array.count)
      let yValuePosition = (yAxisPadding / maxValue) * value
      let yValue = yAxisPadding - yValuePosition
      
      let bar = CGRect(x: 36 + (xValue * Double(i)), y: yValue, width: xValue - 5, height: (frameHeight() - StaticVariables.sidePadding) - yValue)
      
      context.setFillColor(setBarGraphFillColour)
      context.setStrokeColor(setBarGraphStrokeColour)
      context.setLineWidth(setBarGraphLineWidth)
      
      context.addRect(bar)
      context.drawPath(using: .fillStroke)
    }
    
  }
  
  
  /// Renders the legend - Chart Type is between (Line, Bar and Pie)
  func renderLegend(context: CGContext, chartType: String) {
    
    let width = frameWidth()
    
    let rectangleLegend = CGRect(x: width - 50, y: 20, width: 10, height: 10)
    
    if chartType == "Line" {
      context.setFillColor(UIColor.black.cgColor)
    } else {
      context.setFillColor(UIColor.black.cgColor)
    }
    context.setLineWidth(1.0)
    context.addRect(rectangleLegend)
    context.drawPath(using: .fill)
    
    let textFrame = CGRect(x: width - 35, y: 15, width: 30, height: 20)
    
    helper.createLabel(text: "Dataset 1", textFrame: textFrame)
    
    
  }
  
  
  
  
}


