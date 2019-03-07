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
  
  /// Returns true if Y gridline is visible
  open var isYGridlineVisible: Bool { get {return enableYGridline} }
  
  /// Enable the X gridline on the chart
  open var enableXGridline = true
  
  /// Returns true if X gridline is visible
  open var isXGridlineVisible: Bool { get {return enableXGridline} }
  
  /// Set the Y Axis base colour (Default = Black)
  open var setYAxisBaseColour = UIColor.black.cgColor
  
  /// Set the X Axis base colour (Default = Black)
  open var setXAxisBaseColour = UIColor.black.cgColor
  
  /// Set Gridline colour (Default = Black)
  open var setGridlineColour = UIColor.black.cgColor
  
  /// Set Gridline Line Width (Default = 0.5)
  open var setGridlineWidth = CGFloat(0.5)
  
  /// Set the Gridline stroke design (Default = True)
  open var enableGridLineDash = true
  
  /// Returns true if gridline dash is enabled
  open var isGridlineDashEnabled: Bool { get {return enableGridLineDash} }
  
  /// Returns the height of the current frame as a double
  func frameHeight() -> Double {
    let frameHeight = Double(frame.size.height)
    
    return frameHeight
  }
  
  /// Returns the width of the current frame as a double
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
    context.setStrokeColor(source.setLineColour)
    context.strokePath()
    context.setLineWidth(source.setLineWidth)
  }
  
  /// Base function for drawing rectangles
  private func drawRectangle(context: CGContext, x: Double, y: Double, width: Double, height: Double, source: BarChartData) {
    let rectangle = CGRect(x: x, y: y, width: width, height: height)
    
    context.setFillColor(source.setBarGraphFillColour)
    context.setStrokeColor(source.setBarGraphStrokeColour)
    context.setLineWidth(source.setBarGraphLineWidth)
    context.addRect(rectangle)
    context.drawPath(using: .fillStroke)
  }
  
  /// Base function for adding bezier curves to a line graph. This should be called by itself and not with drawLines
  private func addBezierCurve(context: CGContext, startingPoint: CGMutablePath, point: CGPoint, control1: CGPoint, control2: CGPoint, source: LineChartData) {
    startingPoint.addCurve(to: point, control1: control1, control2: control2)
    context.addPath(startingPoint)
    context.setStrokeColor(source.setLineColour)
    context.strokePath()
  }
  
  /// Base function for starting a path.
  private func pathStartPoint(startingXValue: Double, startingYValue: Double) -> CGMutablePath{
    let connection = CGMutablePath()
    connection.move(to: CGPoint(x: startingXValue, y: startingYValue))
    return connection
  }
  
  // Add fill to the current path - TODO: It is stil not behaving as intended
  private func addFill(context: CGContext, path: CGPath) {
    context.saveGState()
    context.addPath(path)
    
    // filled is usually drawn with less alpha
    context.setAlpha(0.33)
    
    context.setFillColor(UIColor.black.cgColor)
    context.fillPath()
    
    context.restoreGState()
    
  }
  
  /// Base function for drawing single line graphs. Requires context, the array to be plotted and the max value of the whole data set
  func drawLineGraph(context: CGContext, array: [Double], maxValue: Double, source: LineChartData, initialValue: Double) {
    let calc = LineGraphCalculation(array: array, maxValue: maxValue, offSet: initialValue, frameWidth: frameWidth(), frameHeight: frameHeight())
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    
    let textRenderer = TextRenderer(paragraphStyle: paragraphStyle, font: UIFont.systemFont(ofSize: source.setTextLabelFont), foreGroundColor: source.setTextLabelColour)
    
    let startingYValue = calc.ylineGraphStartPoint()
    let startingXValue = calc.xlineGraphStartPoint()
    
    let path = pathStartPoint(startingXValue: startingXValue, startingYValue: startingYValue)
    
    for (i, value) in array.enumerated() {
      let xValue = calc.xlineGraphPoint(i: i)
      let yValue = calc.ylineGraphPoint(value: value)
      
      
      if source.enableCirclePointVisibility == true {
        drawCirclePoints(context: context, destination: CGPoint(x: xValue, y: yValue), source: source)
      }
      if source.enableLineVisibility == true {
        drawLines(context: context, startingPoint: path, destinationPoint: CGPoint(x: xValue, y: yValue), source: source)
      }
      if source.enableDataPointLabel == true {
        textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: xValue, y: yValue - 15, width: 40, height: 20))
      }
    }
  }
  
  
  
  
  /// Base function for drawing line graphs with bezier curve. Requires context, the array to be plotted and the max value of the whole data set
  func drawBezierCurve(context: CGContext, array: [Double], maxValue: Double, source: LineChartData, initialValue: Double) {
    let calc = LineGraphCalculation(array: array, maxValue: maxValue, offSet: initialValue, frameWidth: frameWidth(), frameHeight: frameHeight())
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    
    let textRenderer = TextRenderer(paragraphStyle: paragraphStyle, font: UIFont.systemFont(ofSize: source.setTextLabelFont), foreGroundColor: source.setTextLabelColour)
    
    let startingYValue = calc.ylineGraphStartPoint()
    let startingXValue = calc.xlineGraphStartPoint()
    
    let path = pathStartPoint(startingXValue: startingXValue, startingYValue: startingYValue)
    let index = Array(array.dropFirst())
    
    for (i, value) in index.enumerated() {
      
      let destination = calc.bezierGraphPoint(i: i, value: value)
      let control1 = calc.bezierControlPoint1(i: i, value: value, intensity: source.setBezierCurveIntensity)
      let control2 = calc.bezierControlPoint2(i: i, value: value, intensity: source.setBezierCurveIntensity)
      
      if source.enableLineVisibility == true {
        addBezierCurve(context: context, startingPoint: path, point: destination, control1: control1, control2: control2, source: source)
      }
      
      if source.enableCirclePointVisibility == true {
        drawCirclePoints(context: context, destination: destination, source: source)
      }
      
      if source.enableDataPointLabel == true {
        textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: destination.x, y: destination.y - 15, width: 40, height: 20))
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
    let calc = GeneralGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), offSet: padding)
    for i in 0...currentFrame.yAxisGridlinesCount {
      let yStartPoint = calc.yGridlineStartPoint(i: i)
      let yEndPoint = calc.yGridlineEndPoint(i: i)
      
      if enableYGridline == true {
        drawGridLines(context: context, start: yStartPoint, end: yEndPoint)
      }
    }
  }
  
  
  /// Renders the X axis Gridlines
  func xAxisGridlines(context: CGContext, arrayCount: Int, initialValue: Double) {
    let calc = GeneralGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), offSet: initialValue, arrayCount: Double(arrayCount))
    
    for i in 0...arrayCount - 1 {
      let startPoint = calc.xGridlineStartPoint(distanceIncrement: i)
      let endPoint = calc.xGridlineEndPoint(distanceIncrement: i)
      
      if enableXGridline == true {
        drawGridLines(context: context, start: startPoint, end: endPoint)
      }
      
    }
  }
  
  
  /// Renders a horizontal bar graph
  func drawHorizontalBarGraph(context: CGContext, array: [Double], maxValue: Double, data: BarChartData, initialValue: Double) {
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: maxValue, offSet: initialValue, arrayCount: Double(array.count))
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    let textRenderer = TextRenderer(paragraphStyle: paragraphStyle, font: UIFont.systemFont(ofSize: data.setTextLabelFont), foreGroundColor: data.setTextLabelColour)
    
    for (i, value) in array.enumerated() {
      let yValue = calc.yHorizontalValue(i: i)
      let xValue = calc.xHorizontalValue()
      let width = calc.horizontalWidth(value: value)
      let height = calc.horizontalHeight()
      let xFrame = calc.xHorizontalTextFrame(value: value)
      let yFrame = calc.yHorizontalTextFrame(i: i)
      
      drawRectangle(context: context, x: xValue, y: yValue, width: width, height: height, source: data)
      textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: xFrame, y: yFrame, width: 40, height: 20))
    }
    
  }
  
  
  // Renders a vertical bar graph with support for multiple data sets
  func drawVerticalBarGraph(context: CGContext, array: [Double], maxValue: Double, data: BarChartData, initialValue: Double, overallCount: Double, arrayCount: Double) {
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: maxValue, offSet: initialValue, arrayCount: Double(array.count))
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    let textRenderer = TextRenderer(paragraphStyle: paragraphStyle, font: UIFont.systemFont(ofSize: data.setTextLabelFont), foreGroundColor: data.setTextLabelColour)
    
    for (i, value) in array.enumerated() {
      
      let width = calc.verticalWidth(count: arrayCount)
      let xValue = calc.xVerticalValue(i: i, dataSetCount: overallCount, count: arrayCount)
      let yValue = calc.yVerticalValue(value: value)
      
      let height = calc.verticalHeight(value: value)
      let xFrame = calc.xVerticalTextFrame(i: i)
      let yFrame = calc.yVerticalTextFrame(value: value)
      
      drawRectangle(context: context, x: xValue, y: yValue, width: width, height: height, source: data)
      
      if data.enableDataPointLabel == true {
        textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: xFrame, y: yFrame, width: 40, height: 20))
      }
      
    }
  }
  
  
  
  
  /// Y Gridlines used by the horizontal bar graph
  func horizontalBarGraphYGridlines(context: CGContext, arrayCount: Int, padding: Double) {
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), offSet: padding, arrayCount: Double(arrayCount))
    for i in 0...arrayCount {
      let yStartPoint = calc.yHorizontalStartGridlines(i: i)
      let yEndPoint = calc.yHorizontalEndGridlines(i: i)
      drawGridLines(context: context, start: yStartPoint, end: yEndPoint)
    }
  }
  
  /// X Gridlines used by the horizontal bar graph
  func horizontalBarGraphXGridlines(context: CGContext, initialValue: Double) {
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), offSet: initialValue, arrayCount: Double(currentFrame.yAxisGridlinesCount))
    
    for i in 0...currentFrame.yAxisGridlinesCount {
      let startPoint = calc.xHorizontalStartGridlines(i: i)
      let endPoint = calc.xHorizontalEndGridlines(i: i)
      
      drawGridLines(context: context, start: startPoint, end: endPoint)
    }
  }
  
  
  func barGraph(context: CGContext, array: [[Double]], initialValue: Double, graphType: String, data: BarChartDataSet, max: Double) {
    for (i, value) in array.enumerated() {
      if graphType == "Vertical" {
        drawVerticalBarGraph(context: context, array: value, maxValue: max, data: data.array[i], initialValue: initialValue, overallCount: Double(i), arrayCount: Double(array.count))
      } else {
        drawHorizontalBarGraph(context: context, array: value, maxValue: max, data: data.array[i], initialValue: initialValue)
      }
    }
  }
  
  
}





