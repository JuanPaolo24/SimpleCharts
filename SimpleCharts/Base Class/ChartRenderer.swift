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


struct frameValues {
  
  ///Current Value = 31
  static let sidePadding = 31.0
  ///Current Value = 62
  static let leftAndRightSidePadding = 62.0
  ///Current Value = 41
  static let extraSidePadding = 41.0
  ///Current Value = 6
  static let yAxisGridlinesCount = 6 //might introduce this as a customisation
}


open class ChartRenderer: UIView {
  
  //General
  /// Enable the Y gridline on the chart
  public var enableYGridline = true
  
  /// Enable the X gridline on the chart
  public var enableXGridline = true
  
  /// Set the Y Axis line colour
  public var setYAxisLineColour = UIColor.black.cgColor
  
  /// Set the X Axis line colour
  public var setXAxisLineColour = UIColor.black.cgColor
  
  /// Set X Gridline colour
  public var setXGridlineColour = UIColor.black.cgColor
  
  /// Set Y Gridline colour
  public var setYGridLineColour = UIColor.black.cgColor
  
  
  //Bar Chart
  /// Set Bar Graph inside colour (Default = Black)
  public var setBarGraphFillColour = UIColor.black.cgColor
  
  /// Set Bar Graph outline colour (Default = Black)
  public var setBarGraphStrokeColour = UIColor.black.cgColor
  
  /// Set Bar Graph Line Width (Default = 1.0)
  public var setBarGraphLineWidth = CGFloat(1.0)
  
  
  
  //Line Chart
  /// Enable the circle points
  public var enableCirclePoint = true
  
  /// Change the properties of the line chart to a dash TODO: Fix a bug where the dash line is changing everything else to dash
  public var enableDash = true
  
  /// Enable the line 
  public var enableLine = true
  
  /// Set Circle Point (Line Graph) colour
  public var setCirclePointColour = UIColor.black.cgColor
  
  /// Set Line Point (Line Graph) colour
  public var setLinePointColour = UIColor.black.cgColor
  
  /// Set Circle Point Radius (Default = 3)
  public var setCirclePointRadius = CGFloat(3.0)
  
  /// Set Line Point Width (Default = 1)
  public var setLinePointWidth = CGFloat(1.0)
  
 
  
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func frameHeight() -> Double {
    let frameHeight = Double(frame.size.height)
    
    return frameHeight
  }
  
  func frameWidth() -> Double {
    let frameWidth = Double(frame.size.width)
    
    return frameWidth
  }
  

  
  
  func yAxisBase(context: CGContext) {
    let yAxisPadding = frameHeight() - frameValues.sidePadding
    
    let yAxisPath = CGMutablePath()
    yAxisPath.move(to: CGPoint(x: 30, y: 10))
    yAxisPath.addLine(to: CGPoint(x: 30, y: yAxisPadding))
    context.addPath(yAxisPath)
    context.setLineWidth(3.0)
    context.setStrokeColor(setYAxisLineColour)
    context.strokePath()
  }
  
  func yAxis(context: CGContext, array: [Double]) {
    let frameScale = (frameHeight() - frameValues.extraSidePadding) / Double(frameValues.yAxisGridlinesCount)
    let yAxisPadding = frameHeight() - frameValues.sidePadding
    let xAxisPadding = frameWidth() - frameValues.leftAndRightSidePadding
    var maxValue = 0.0
    var actualDataScale = 0
    
    if let max = array.max() {
      maxValue = max + 41
      actualDataScale =  Int(maxValue / 6)

    }
    
    for i in 0...frameValues.yAxisGridlinesCount {
      
      let valueIncrement = Double(i)
      let actualValue = frameScale * valueIncrement
      
      if enableYGridline == true {
        let yGridLine = CGMutablePath()
        yGridLine.move(to: CGPoint(x: 30, y: yAxisPadding - actualValue))
        yGridLine.addLine(to: CGPoint(x: xAxisPadding, y: yAxisPadding - actualValue))
        
        context.addPath(yGridLine)
        context.setStrokeColor(setYGridLineColour)
        context.strokePath()
        context.setLineWidth(1.0)
      }
      
      
      if enableDash == true {
        context.setLineDash(phase: 0, lengths: [1])
      }
      
      
      let yAxisLabel = axisLabel(name: String(i * actualDataScale))
      yAxisLabel.frame = CGRect(x: 0, y: frameHeight() - 36 - actualValue, width: 20, height: 20)
      
      addSubview(yAxisLabel)
    }
    
  }
  
  func xAxisBase(context: CGContext) {
    
    let yAxisPadding = frameHeight() - frameValues.sidePadding
    let xAxisPadding = frameWidth() - frameValues.leftAndRightSidePadding
    
    let xAxisPath = CGMutablePath()
    xAxisPath.move(to: CGPoint(x: 30, y: yAxisPadding))
    xAxisPath.addLine(to: CGPoint(x: xAxisPadding, y: yAxisPadding))
    context.addPath(xAxisPath)
    context.setLineWidth(3.0)
    context.setStrokeColor(setXAxisLineColour)
    context.strokePath()
  }
  
  
  /// Renders the X axis gridline and axis labels
  func xAxis(context: CGContext, array: [Double]) {
    let yAxisPadding = frameHeight() - frameValues.sidePadding
    let pointIncrement = (frameWidth() - frameValues.leftAndRightSidePadding) / Double(array.count)
    
    
    for i in 0...array.count - 1 {
      
      let xValue = calculatexValue(pointIncrement: pointIncrement, distanceIncrement: i, sideMargin: frameValues.extraSidePadding)
      
      if enableXGridline == true {
        let xAxisGridline = CGMutablePath()
        xAxisGridline.move(to: CGPoint(x: xValue, y: 10))
        xAxisGridline.addLine(to: CGPoint(x: xValue, y: yAxisPadding))
        context.addPath(xAxisGridline)
        context.setStrokeColor(setXGridlineColour)
        context.strokePath()
        context.setLineWidth(1.0)
      }
      
      if enableDash == true {
        context.setLineDash(phase: 0, lengths: [1])
      }
      
      let xAxisLabel = axisLabel(name: String(i + 1))
      xAxisLabel.frame = CGRect(x: xValue, y: frameHeight() - 28, width: 20, height: 20)
      addSubview(xAxisLabel)
    }
    
  }
  
  // Make this function clear
  func calculatexValue(pointIncrement: Double, distanceIncrement: Int, sideMargin: Double) -> Double {
    var xValue = 0.0
    var marker = 0.0
    if pointIncrement > sideMargin {
      marker = pointIncrement - sideMargin
      xValue = Double((pointIncrement * (Double(distanceIncrement) + 1.0)) - marker)
    } else {
      marker = sideMargin - pointIncrement
      xValue = Double((pointIncrement * (Double(distanceIncrement) + 1.0)) + marker)
    }
    
    return xValue
  }
  
  
  func axisLabel(name: String) -> UILabel {
    let label = UILabel(frame: CGRect.zero)
    label.text = name
    label.font = UIFont.systemFont(ofSize: 8)
    label.textColor = UIColor.black
    label.backgroundColor = UIColor.white
    label.textAlignment = NSTextAlignment.left
    
    return label
  }
  
  /// Draws a circle on the destination coordinates (CGPoint)
  func drawCirclePoints(context: CGContext, destination: CGPoint) {
    context.addArc(center: destination, radius: setCirclePointRadius, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
    context.setFillColor(setCirclePointColour)
    context.fillPath()
    
  }
  
  /// Draws a line from the a start point(Mutable Path) to a destination point (CGPoint)
  func drawLines(context: CGContext, startingPoint: CGMutablePath, destinationPoint: CGPoint) {
    
    startingPoint.addLine(to: destinationPoint)
    context.addPath(startingPoint)
    context.setStrokeColor(setLinePointColour)
    context.strokePath()
    context.setLineWidth(setLinePointWidth)
  }
  
  
  /// Renders and plots the line graph (Both the line and the circle point)
  func renderLineGraph(context: CGContext, array: [Double]) {
    let connection = CGMutablePath()
    let yAxisPadding = frameHeight() - frameValues.extraSidePadding
    let arrayCount = Double(array.count)
    let pointIncrement = (frameWidth() - frameValues.leftAndRightSidePadding) / arrayCount
    var maxValue = 0.0
    
    
    if let max = array.max() {
      maxValue = max + 41
      if let firstValue = array.first {
        let yValue = (yAxisPadding / maxValue) * firstValue
        connection.move(to: CGPoint(x: calculatexValue(pointIncrement: pointIncrement, distanceIncrement: 0, sideMargin: 41.0), y: yAxisPadding - yValue))
      }
    }
    
    for (i, value) in array.enumerated() {
      
      let xValue = calculatexValue(pointIncrement: pointIncrement, distanceIncrement: i, sideMargin: 41.0)
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
  
  /// Renders a vertical bar graph
  func renderVerticalBarGraph(context: CGContext, array: [Double]) {
    var maxValue = 0.0
    let yAxisPadding = (frameHeight() - frameValues.extraSidePadding)
    
    if let max = array.max() {
      maxValue = max + 41
    }
    
    for (i, value) in array.enumerated() {
      
      let xValue = (frameWidth() - 93) / Double(array.count)
      let yValuePosition = (yAxisPadding / maxValue) * value
      let yValue = yAxisPadding - yValuePosition
      
      let bar = CGRect(x: 36 + (xValue * Double(i)), y: yValue, width: xValue - 5, height: (frameHeight() - frameValues.sidePadding) - yValue)
      
      context.setFillColor(setBarGraphFillColour)
      context.setStrokeColor(setBarGraphStrokeColour)
      context.setLineWidth(setBarGraphLineWidth)
      
      context.addRect(bar)
      context.drawPath(using: .fillStroke)
    }
  }
  
}


