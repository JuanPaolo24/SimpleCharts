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
    
    context.setFillColor(source.setLineGraphColour)
    context.fillPath()
    
    

  }
  
  /// Base function for drawing lines from the a start point(Mutable Path) to a destination point (CGPoint)
  private func drawLines(context: CGContext, startingPoint: CGMutablePath, destinationPoint: CGPoint, source: LineChartData) {
    startingPoint.addLine(to: destinationPoint)
    context.addPath(startingPoint)
    context.setStrokeColor(source.setLineGraphColour)
    context.strokePath()
    context.setLineWidth(source.setLineWidth)
    
  }
  
  
  private func drawFillLine(context: CGContext, startingPoint: CGMutablePath, destinationPoint: CGPoint) {
    startingPoint.addLine(to: destinationPoint)
    context.addPath(startingPoint)
    context.setStrokeColor(UIColor.clear.cgColor)
    context.strokePath()
    context.setLineWidth(3)
    
    
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
    context.setStrokeColor(source.setLineGraphColour)
    context.strokePath()
  }
  
  private func drawBezierFill(context: CGContext, startingPoint: CGMutablePath, point: CGPoint, control1: CGPoint, control2: CGPoint) {
    startingPoint.addCurve(to: point, control1: control1, control2: control2)
    context.addPath(startingPoint)
    context.setStrokeColor(UIColor.clear.cgColor)
    context.strokePath()
  }
  
  /// Base function for starting a path.
  private func pathStartPoint(startingXValue: Double, startingYValue: Double) -> CGMutablePath{
    let connection = CGMutablePath()
    connection.move(to: CGPoint(x: startingXValue, y: startingYValue))
    return connection
  }
  

  // Add fill to the current path
  private func addFill(context: CGContext, path: CGMutablePath) {
    context.saveGState()
    context.beginPath()
    context.addPath(path)
    
    context.setFillColor(UIColor.red.cgColor)
    context.setAlpha(0.33)
    context.fillPath()
    context.restoreGState()
    
  }
  
  
  /// Base function for drawing single line graphs. Requires context, the array to be plotted and the max value of the whole data set
  func drawLineGraph(context: CGContext, array: [Double], maxValue: Double, source: LineChartData, forCombined: Bool, offSet: offset, xGridlineCount: Double, yGridlineCount: Double) {
    let calc = LineGraphCalculation(array: array, arrayCount: 0, maxValue: maxValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yGridlineCount, xAxisGridlineCount: xGridlineCount)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    
    let textRenderer = TextRenderer(paragraphStyle: paragraphStyle, font: UIFont.systemFont(ofSize: source.setTextLabelFont), foreGroundColor: source.setTextLabelColour)
    
    
    let startingYValue = calc.ylineGraphStartPoint()
    var startingXValue: Double = 0.0
    
    if forCombined == true {
      startingXValue = calc.xlineCombinePoint(i: 0)
    } else {
      startingXValue = calc.xlineGraphPoint(i: 0)
    }
    
    let path = pathStartPoint(startingXValue: startingXValue, startingYValue: startingYValue)
    
    let path2 = pathStartPoint(startingXValue: startingXValue, startingYValue: frameHeight() - offSet.bottom)
    
    var xValue: Double = 0.0
    var yValue: Double = 0.0
    
    for (i, value) in array.enumerated() {
      
      
      if forCombined == true {
        xValue = calc.xlineCombinePoint(i: i)
      } else {
        xValue = calc.xlineGraphPoint(i: i)
      }
      
      yValue = calc.ylineGraphPoint(value: value)
      
      if source.enableCirclePointVisibility == true {
        drawCirclePoints(context: context, destination: CGPoint(x: xValue, y: yValue), source: source)

      }
      if source.enableLineVisibility == true {
        drawLines(context: context, startingPoint: path, destinationPoint: CGPoint(x: xValue, y: yValue), source: source)
        drawFillLine(context: context, startingPoint: path2, destinationPoint: CGPoint(x: xValue, y: yValue))
        
      }
      if source.enableDataPointLabel == true {
        textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: xValue, y: yValue - 15, width: 40, height: 20))
      }
    }
    
    if source.enableGraphFill == true {
      drawFillLine(context: context, startingPoint: path2, destinationPoint: CGPoint(x: xValue, y: frameHeight() - offSet.bottom))
      
      addFill(context: context, path: path2)
    }
    
  }
  

  
  /// Base function for drawing line graphs with bezier curve. Requires context, the array to be plotted and the max value of the whole data set
  func drawBezierCurve(context: CGContext, array: [Double], maxValue: Double, source: LineChartData, forCombined:Bool, offSet: offset, xGridlineCount: Double, yGridlineCount: Double) {
    let calc = LineGraphCalculation(array: array, arrayCount: 0, maxValue: maxValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yGridlineCount, xAxisGridlineCount: xGridlineCount)
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    
    let textRenderer = TextRenderer(paragraphStyle: paragraphStyle, font: UIFont.systemFont(ofSize: source.setTextLabelFont), foreGroundColor: source.setTextLabelColour)
    
    let startingYValue = calc.ylineGraphStartPoint()
    var startingXValue = 0.0
    
    if forCombined == true {
      startingXValue = calc.xlineCombinePoint(i: 0)
    } else {
      startingXValue = calc.xlineGraphPoint(i: 0)
    }
    
    let path = pathStartPoint(startingXValue: startingXValue, startingYValue: startingYValue)
    drawCirclePoints(context: context, destination: CGPoint(x: startingXValue, y: startingYValue), source: source)
    let path2 = pathStartPoint(startingXValue: startingXValue, startingYValue: frameHeight() - offSet.bottom)
    
    var destination = CGPoint()
    var control1 = CGPoint()
    var control2 = CGPoint()
    
    let index = Array(array.dropFirst())
    
    for (i, value) in index.enumerated() {
      
      if forCombined == true {
        destination = calc.bezierCombinePoint(i: i, value: value)
        control1 = calc.bezierControlCombinedPoint(i: i, value: value, intensity: source.setBezierCurveIntensity, isControl1: true)
        control2 = calc.bezierControlCombinedPoint(i: i, value: value, intensity: source.setBezierCurveIntensity, isControl1: false)
      } else {
        destination = calc.bezierGraphPoint(i: i, value: value)
        control1 = calc.bezierControlPoint(i: i, value: value, intensity: source.setBezierCurveIntensity, isControl1: true)
        control2 = calc.bezierControlPoint(i: i, value: value, intensity: source.setBezierCurveIntensity, isControl1: false)
      }
      
      
      if source.enableLineVisibility == true {
        addBezierCurve(context: context, startingPoint: path, point: destination, control1: control1, control2: control2, source: source)
        drawBezierFill(context: context, startingPoint: path2, point: destination, control1: control1, control2: control2)
      }
      
      if source.enableCirclePointVisibility == true {
        drawCirclePoints(context: context, destination: destination, source: source)
      }
      
      if source.enableDataPointLabel == true {
        textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: destination.x, y: destination.y - 15, width: 40, height: 20))
      }
    
    }
    
    if source.enableGraphFill == true {
      drawFillLine(context: context, startingPoint: path2, destinationPoint: CGPoint(x: Double(destination.x), y: frameHeight() - offSet.bottom))
      addFill(context: context, path: path2)
    }
  }
  
  
  /// A function that draws the Y axis line used by Line and Bar Graph
  func yAxisBase(context: CGContext, offSet: offset) {
    let yAxisPadding = frameHeight() - offSet.bottom
    let xAxisPadding = frameWidth() - offSet.right
    
    let leftBaseStartPoint = CGPoint(x: offSet.left, y: offSet.top)
    let leftBaseEndPoint = CGPoint(x: offSet.left, y: yAxisPadding)
    
    let rightBaseStartPoint = CGPoint(x: xAxisPadding, y: offSet.top)
    let rightBaseEndPoint = CGPoint(x: xAxisPadding, y: yAxisPadding)
    
    drawAxisBase(context: context, start: leftBaseStartPoint, end: leftBaseEndPoint, strokeColour: setYAxisBaseColour, width: 3.0)
    drawAxisBase(context: context, start: rightBaseStartPoint, end: rightBaseEndPoint, strokeColour: setYAxisBaseColour, width: 3.0)
  }
  
  /// A function that draw the X axis line used by Line and Bar Graph
  
  func xAxisBase(context: CGContext, offSet: offset) {
    
    let yAxisPadding = frameHeight() - offSet.bottom
    let xAxisPadding = frameWidth() - offSet.right
    
    let bottomBaseStartPoint = CGPoint(x: offSet.left, y: yAxisPadding)
    let bottomBaseEndPoint = CGPoint(x: xAxisPadding, y: yAxisPadding)
    
    let upperBaseStartPoint = CGPoint(x: offSet.left, y: offSet.top)
    let upperBaseEndPoint = CGPoint(x: xAxisPadding, y: offSet.top)
    
    drawAxisBase(context: context, start: bottomBaseStartPoint, end: bottomBaseEndPoint, strokeColour: setXAxisBaseColour, width: 2.0)
    drawAxisBase(context: context, start: upperBaseStartPoint, end: upperBaseEndPoint, strokeColour: setXAxisBaseColour, width: 2.0)
    
  }
  
  
  /// Renders the Y axis Gridlines
  func yAxisGridlines(context: CGContext, offSet: offset, gridlineCount: Double) {
    let calc = GeneralGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), arrayCount: 0, offSet: offSet, yAxisGridlineCount: gridlineCount, xAxisGridlineCount: 0)
    
    for i in 0...Int(gridlineCount) {
      let yStartPoint = calc.yGridlinePoint(i: i, destination: position.start)
      let yEndPoint = calc.yGridlinePoint(i: i, destination: position.end)
      
      if enableYGridline == true {
        drawGridLines(context: context, start: yStartPoint, end: yEndPoint)
      }
    }
  }
  
  
  /// Renders the X axis Gridlines
  func xAxisGridlines(context: CGContext, arrayCount: Int, offSet: offset, gridlineCount: Double) {
    let calc = GeneralGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), arrayCount: Double(arrayCount), offSet: offSet, yAxisGridlineCount: 0, xAxisGridlineCount: gridlineCount)
    
    
    for i in 0...Int(gridlineCount) {
      let startPoint = calc.xGridlinePoint(distanceIncrement: i, destination: position.start)
      let endPoint = calc.xGridlinePoint(distanceIncrement: i, destination: position.end)
      if enableXGridline == true {
        drawGridLines(context: context, start: startPoint, end: endPoint)
      }
      
    }
  }
  
  /// Renders a special X axis gridline for the bar chart
  func barxAxisGridlines(context: CGContext, arrayCount: Int, offSet: offset) {
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: 0, arrayCount: Double(arrayCount), offSet: offSet)
    
    for i in 0...arrayCount - 1 {
      let startPoint = calc.xGridlineStartCalculation(distanceIncrement: i)
      let endPoint = calc.xGridlineEndCalculation(distanceIncrement: i)
      
      if enableXGridline == true {
        drawGridLines(context: context, start: startPoint, end: endPoint)
      }
      
    }
  
  }
  
  
  /// Renders a horizontal bar graph
  func drawHorizontalBarGraph(context: CGContext, array: [Double], maxValue: Double, data: BarChartData, overallCount: Double, arrayCount: Double, offSet: offset) {

    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: maxValue, arrayCount: Double(array.count), offSet: offSet)
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    let textRenderer = TextRenderer(paragraphStyle: paragraphStyle, font: UIFont.systemFont(ofSize: data.setTextLabelFont), foreGroundColor: data.setTextLabelColour)
    
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
  func drawVerticalBarGraph(context: CGContext, array: [Double], maxValue: Double, data: BarChartData, overallCount: Double, arrayCount: Double, offSet: offset) {
    
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: maxValue, arrayCount: Double(array.count), offSet: offSet)
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    let textRenderer = TextRenderer(paragraphStyle: paragraphStyle, font: UIFont.systemFont(ofSize: data.setTextLabelFont), foreGroundColor: data.setTextLabelColour)
    
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
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: 0, arrayCount: Double(arrayCount), offSet: offSet)
    for i in 0...arrayCount {
      let yStartPoint = calc.yHorizontalGridline(i: i, destination: position.start)
      let yEndPoint = calc.yHorizontalGridline(i: i, destination: position.end)
      drawGridLines(context: context, start: yStartPoint, end: yEndPoint)
    }
  }
  
  /// X Gridlines used by the horizontal bar graph
  func horizontalBarGraphXGridlines(context: CGContext, offSet: offset, gridline: Double) {
    let calc = BarGraphCalculation(frameHeight: frameHeight(), frameWidth: frameWidth(), maxValue: 0, arrayCount: gridline, offSet: offSet)
    
    for i in 0...Int(gridline) {
      let startPoint = calc.xHorizontalGridline(i: i, destination: position.start)
      let endPoint = calc.xHorizontalGridline(i: i, destination: position.end)
      
      drawGridLines(context: context, start: startPoint, end: endPoint)
    }
  }
  
  
 
  
}





