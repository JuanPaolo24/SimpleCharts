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
  
  
  /// An instance of the RendererHelper class for access to helper functions
  private var helper = RendererHelper()
  
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
  
  /// Base function for drawing circle on the destination coordinates (CGPoint)
  private func drawCirclePoints(context: CGContext, destination: CGPoint, source: LineChartData) {
    context.addArc(center: destination, radius: source.setCirclePointRadius, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
    context.setFillColor(source.setCirclePointColour)
    context.fillPath()
    
  }
  
  /// Base function for drawing lines from the a start point(Mutable Path) to a destination point (CGPoint)
  private func drawLines(context: CGContext, startingPoint: CGMutablePath, destinationPoint: CGPoint, source: LineChartData) {
    startingPoint.addLine(to: destinationPoint)
    context.addPath(startingPoint)
    context.setStrokeColor(source.setLinePointColour)
    context.strokePath()
    context.setLineWidth(source.setLineWidth)
  }
  
  private func drawRectangle(context: CGContext, x: Double, y: Double, width: Double, height: Double, source: BarChartData) {
    let rectangle = CGRect(x: x, y: y, width: width, height: height)
    
    context.setFillColor(source.setBarGraphFillColour)
    context.setStrokeColor(source.setBarGraphStrokeColour)
    context.setLineWidth(source.setBarGraphLineWidth)
    context.addRect(rectangle)
    context.drawPath(using: .fillStroke)
  }
  
  
   /// Base function for drawing single line graphs. Requires context, the array to be plotted and the max value of the whole data set
  func drawLineGraph(context: CGContext, array: [Double], maxValue: Double, source: LineChartData, initialValue: Double) {
    let connection = CGMutablePath()
    let yAxisPadding = frameHeight() - currentFrame.distanceFromBottom
    let arrayCount = Double(array.count)

    let xStartingPoint = helper.calculatexValue(frameWidth: frameWidth(), arrayCount: arrayCount, distanceIncrement: 0, initialValue: initialValue)

    if let firstValue = array.first {
      let yValue = (yAxisPadding / maxValue) * firstValue
      connection.move(to: CGPoint(x: xStartingPoint, y: yAxisPadding - yValue))
    }

    for (i, value) in array.enumerated() {
      let xValue = helper.calculatexValue(frameWidth: frameWidth(), arrayCount: arrayCount, distanceIncrement: i, initialValue: initialValue)

      let yValue = yAxisPadding - ((yAxisPadding / maxValue) * value)
      
      if source.enableCirclePoint == true {
        drawCirclePoints(context: context, destination: CGPoint(x: xValue, y: yValue), source: source)
      }

      if source.enableLine == true {
        drawLines(context: context, startingPoint: connection, destinationPoint: CGPoint(x: xValue, y: yValue), source: source)
      }

      if source.enableDataPointLabel == true {
        helper.renderText(text: "\(value)", textFrame: CGRect(x: xValue, y: yValue - 15, width: 40, height: 20))
      }
    }
  }

  
  
  /// A function that draws the Y axis line used by Line and Bar Graph
  func yAxisBase(context: CGContext, padding: Double) {
    let yAxisPadding = frameHeight() - currentFrame.distanceFromBottom
    let leftBaseStartPoint = CGPoint(x: padding, y: 10)
    let leftBaseEndPoint = CGPoint(x: padding, y: yAxisPadding)
    
    let rightBaseStartPoint = CGPoint(x: frameWidth() - padding, y: 10)
    let rightBaseEndPoint = CGPoint(x: frameWidth() - padding, y: yAxisPadding)
    
    drawAxisBase(context: context, start: leftBaseStartPoint, end: leftBaseEndPoint, strokeColour: setYAxisBaseColour, width: 3.0)
    drawAxisBase(context: context, start: rightBaseStartPoint, end: rightBaseEndPoint, strokeColour: setYAxisBaseColour, width: 3.0)
  }
  
  /// A function that draw the X axis line used by Line and Bar Graph
  
  func xAxisBase(context: CGContext, padding: Double) {
    
    let yAxisPadding = frameHeight() - currentFrame.distanceFromBottom
    let xAxisPadding = frameWidth() - padding
    
    let bottomBaseStartPoint = CGPoint(x: padding, y: yAxisPadding)
    let bottomBaseEndPoint = CGPoint(x: xAxisPadding, y: yAxisPadding)
    
    let upperBaseStartPoint = CGPoint(x: padding, y: 10)
    let upperBaseEndPoint = CGPoint(x: xAxisPadding, y: 10)
    
    drawAxisBase(context: context, start: bottomBaseStartPoint, end: bottomBaseEndPoint, strokeColour: setXAxisBaseColour, width: 2.0)
    drawAxisBase(context: context, start: upperBaseStartPoint, end: upperBaseEndPoint, strokeColour: setXAxisBaseColour, width: 2.0)
    
  }
  

  /// Renders the Y axis Gridlines
  func yAxisGridlines(context: CGContext, padding: Double) {
    let frameScale = (frameHeight() - currentFrame.distanceFromBottom) / Double(currentFrame.yAxisGridlinesCount)
    let yAxisPadding = frameHeight() - currentFrame.distanceFromBottom
    let xAxisPadding = frameWidth() - padding
    
    for i in 0...currentFrame.yAxisGridlinesCount {
      let valueIncrement = Double(i)
      let actualValue = frameScale * valueIncrement
      
      let yStartPoint = CGPoint(x: padding, y: yAxisPadding - actualValue)
      let yEndPoint = CGPoint(x: xAxisPadding, y: yAxisPadding - actualValue)
      
      if enableYGridline == true {
        drawGridLines(context: context, start: yStartPoint, end: yEndPoint)
      }
    }
  }
  
  
  /// Renders the X axis Gridlines
  func xAxisGridlines(context: CGContext, arrayCount: Int, initialValue: Double) {
    let yAxisPadding = frameHeight() - currentFrame.distanceFromBottom
    
    for i in 0...arrayCount - 1 {
      let xValue = helper.calculatexValue(frameWidth: frameWidth(),arrayCount: Double(arrayCount), distanceIncrement: i, initialValue: initialValue)
      
      let startPoint = CGPoint(x: xValue, y: 10)
      let endPoint = CGPoint(x: xValue, y: yAxisPadding)
      
      if enableXGridline == true {
        drawGridLines(context: context, start: startPoint, end: endPoint)
      }
    }
  }
  
  /// Renders a vertical bar graph
  func drawVerticalBarGraph(context: CGContext, array: [Double], maxValue: Double, data: BarChartData, initialValue: Double) {
    let yAxisPadding = (frameHeight() - currentFrame.distanceFromBottom)
    
    for (i, value) in array.enumerated() {
      let xValue = (frameWidth() - (initialValue * 2)) / Double(array.count)
      let yValuePosition = (yAxisPadding / maxValue) * value
      let yValue = yAxisPadding - yValuePosition

      drawRectangle(context: context, x: initialValue + (xValue * Double(i)), y: yValue, width: xValue - 5, height: (frameHeight() - currentFrame.distanceFromBottom) - yValue, source: data)
      helper.renderText(text: "\(value)", textFrame: CGRect(x: (initialValue + 5) + (xValue * Double(i)), y: yValue - 15, width: 40, height: 20))
    }
  }
  
  
  /// Renders a horizontal bar graph
  func drawHorizontalBarGraph(context: CGContext, array: [Double], maxValue: Double, data: BarChartData, initialValue: Double) {
    let xAxisPadding = (frameWidth() - currentFrame.distanceFromBottom)
    var labelPadding = 25.0
    
    if initialValue == 70 {
      labelPadding = 10.0
    }

    for (i, value) in array.enumerated() {
      let yValue = (frameHeight() - 62) / Double(array.count)
      let xValue = ((xAxisPadding / maxValue) * value) - (initialValue - 30) // Ensures that the extra padding on the landscape version gets added
      
      drawRectangle(context: context, x: initialValue, y: 20 + (yValue * Double(i)), width: xValue, height: yValue - 35, source: data)
      helper.renderText(text: "\(value)", textFrame: CGRect(x: (initialValue + xValue) + 5, y: labelPadding + (yValue * Double(i)), width: 40, height: 20))
    }
    
  }
  
  
  /// Y Gridlines used by the horizontal bar graph
  func horizontalBarGraphYGridlines(context: CGContext, arrayCount: Int, padding: Double) {
    let yAxisPadding = frameHeight() - currentFrame.distanceFromBottom
    let xAxisPadding = frameWidth() - padding
    
    for i in 0...arrayCount {
      let frameScale = (frameHeight() - currentFrame.distanceFromBottom) / Double(arrayCount)
      let actualValue = frameScale * Double(i)
      
      let yStartPoint = CGPoint(x: padding, y: yAxisPadding - actualValue)
      let yEndPoint = CGPoint(x: xAxisPadding, y: yAxisPadding - actualValue)
      drawGridLines(context: context, start: yStartPoint, end: yEndPoint)
    }
  }
  
  /// X Gridlines used by the horizontal bar graph
  func horizontalBarGraphXGridlines(context: CGContext, initialValue: Double) {
    let yAxisPadding = frameHeight() - currentFrame.distanceFromBottom
    
    for i in 0...currentFrame.yAxisGridlinesCount {
      let xValue = helper.calculatexValue(frameWidth: frameWidth(), arrayCount: Double(currentFrame.yAxisGridlinesCount + 1), distanceIncrement: i, initialValue: initialValue)
      
      let startPoint = CGPoint(x: xValue, y: 10)
      let endPoint = CGPoint(x: xValue, y: yAxisPadding)
      drawGridLines(context: context, start: startPoint, end: endPoint)
    }
  }
  

  func barGraph(context: CGContext, array: [[Double]], initialValue: Double, graphType: String, data: BarChartDataSet, max: Double) {
    for (i, value) in array.enumerated() {
      if graphType == "Vertical" {
        drawVerticalBarGraph(context: context, array: value, maxValue: max, data: data.array[i], initialValue: initialValue)
      } else {
        drawHorizontalBarGraph(context: context, array: value, maxValue: max, data: data.array[i], initialValue: initialValue)
      }
    }
  }

  
}





