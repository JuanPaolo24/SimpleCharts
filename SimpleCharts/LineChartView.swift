//
//  LineChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 25/01/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation
import CoreGraphics


extension FloatingPoint {
  var degreesToRadians: Self {return self * .pi / 180}
}


open class LineChartView: UIView {
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard let context = UIGraphicsGetCurrentContext() else {
      print("could not get context")
      return
    }
    
    //let valuetest: [Double] = [130, 55, 100, 50, 120]
    
    let valuetest: [Double] = [500, 550, 1200, 800, 940]
    
    //let valuetest: [Double] = [8, 104, 81, 93, 52, 44, 97, 101, 75, 28, 76, 25, 20, 13, 52, 44, 57, 23, 45, 91, 99, 14, 84, 48, 40, 71, 106, 41, 45, 61]
    
    
    
    plotPoints(context: context, rect: rect, array: valuetest, circleEnabled: true, lineEnabled: true)
    drawAxis(context: context, rect: rect)
    drawAxisGridLines(context: context, rect: rect, array: valuetest, isGridline: true)
    axisMark(rect: rect, array: valuetest)
    
  }
  
  
  
  func drawAxis(context: CGContext, rect: CGRect) {
    let yAxisPadding = rect.size.height - 31
    let xAxisPadding = rect.size.width - 31
    
    let yAxisPath = CGMutablePath()
    yAxisPath.move(to: CGPoint(x: 30, y: 10))
    yAxisPath.addLine(to: CGPoint(x: 30, y: yAxisPadding))
    
    let xAxisPath = CGMutablePath()
    xAxisPath.move(to: CGPoint(x: 30, y: yAxisPadding))
    xAxisPath.addLine(to: CGPoint(x: xAxisPadding, y: yAxisPadding))
    
    context.addPath(yAxisPath)
    context.addPath(xAxisPath)
    context.setLineWidth(3.0)
    context.setStrokeColor(UIColor.black.cgColor)
    context.strokePath()
    
  }
  
  
  func plotPoints(context: CGContext, rect: CGRect, array: [Double], circleEnabled: Bool, lineEnabled: Bool) {
    let connection = CGMutablePath()
    let yAxisPadding = rect.size.height - 41
    let arrayCount = Double(array.count)
    let pointIncrement = Double(rect.size.width - 62) / arrayCount
    var yValue = 0.0
    var maxValue = 0.0
    
    
    if let max = array.max() {
      maxValue = max + 41
      if let firstValue = array.first {
        let yValue = (Double(yAxisPadding) / maxValue) * firstValue
        
        connection.move(to: CGPoint(x: calculatexValue(pointIncrement: pointIncrement, i: 0, sideMargin: 41.0), y: Double(yAxisPadding) - yValue))
      }
    }
    
    for (i, value) in array.enumerated() {

      let xValue = calculatexValue(pointIncrement: pointIncrement, i: i, sideMargin: 41.0)

      yValue = (Double(yAxisPadding) / maxValue) * value
      
      print(yValue)
      
      if circleEnabled == true {
        drawCirclePoints(context: context, xValue: xValue, yValue: yValue, yAxisPadding: yAxisPadding, radius: 3, lineWidth: 1.0, colour: UIColor.black.cgColor)
      }
      
      if lineEnabled == true {
        drawLines(context: context, connection: connection, xValue: xValue, yValue: yValue, yAxisPadding: yAxisPadding, lineWidth: 1.0, colour: UIColor.black.cgColor)
      }
    }
  }
  
  
  //Ensures that there is sufficient padding at the start and end of the x axis
  func calculatexValue(pointIncrement: Double, i: Int, sideMargin: Double) -> Double {
    var xValue = 0.0
    var marker = 0.0
    if pointIncrement > sideMargin {
      marker = pointIncrement - sideMargin
      xValue = Double((pointIncrement * (Double(i) + 1.0)) - marker)
    } else {
      marker = sideMargin - pointIncrement
      xValue = Double((pointIncrement * (Double(i) + 1.0)) + marker)
    }
    
    return xValue
  }
  
  
  
  func drawCirclePoints(context: CGContext, xValue: Double, yValue: Double, yAxisPadding: CGFloat, radius: CGFloat, lineWidth: CGFloat, colour: CGColor) {
    context.addArc(center: CGPoint(x: xValue, y: Double(yAxisPadding) - yValue), radius: radius, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
    context.setLineWidth(lineWidth)
    context.setFillColor(colour)
    context.fillPath()
    
  }
  
  
  func drawLines(context: CGContext, connection: CGMutablePath, xValue: Double, yValue: Double, yAxisPadding: CGFloat, lineWidth: CGFloat, colour: CGColor) {
    connection.addLine(to: CGPoint(x: xValue, y: Double(yAxisPadding) - yValue))
    context.addPath(connection)
    context.setStrokeColor(colour)
    context.strokePath()
    context.setLineWidth(lineWidth)
  }
  
  
  
  
  func drawAxisGridLines(context: CGContext, rect: CGRect, array: [Double], isGridline: Bool) {
    let arrayCount = array.count
    var actualDataScale = 0.0
    var windowCount = 0.0
    var frameScale = 0.0
    let pointIncrement = Double(rect.size.width - 62) / Double(array.count)
    
    if let max = array.max() {
      let maxValue = max + 41
      //Manipulate the value at the end of this to create distance between the axis
      actualDataScale =  maxValue / 6
      windowCount = 6
      frameScale = (Double(rect.size.height - 41) / 6)
    }
    
  
    if isGridline == true {
      for i in 0...Int(windowCount) {
      
        let secondGridLine = CGMutablePath()
        secondGridLine.move(to: CGPoint(x: 30, y: Double(rect.size.height - 31) - (frameScale * Double(i))))
        secondGridLine.addLine(to: CGPoint(x: Double(rect.size.width - 31), y: Double(rect.size.height - 31) - (frameScale * Double(i))))
        
        
        context.addPath(secondGridLine)
        context.setStrokeColor(UIColor.black.cgColor)
        context.strokePath()
        context.setLineWidth(1.0)
        
      }
      
      for i in 0...array.count - 1 {
        
        
        let xValue = calculatexValue(pointIncrement: pointIncrement, i: i, sideMargin: 41.0)
        
        let firstGridLine = CGMutablePath()
        firstGridLine.move(to: CGPoint(x: xValue, y: 10))
        firstGridLine.addLine(to: CGPoint(x: xValue, y: Double(rect.size.height - 31)))
        context.addPath(firstGridLine)
        
        context.setStrokeColor(UIColor.black.cgColor)
        context.strokePath()
        context.setLineWidth(1.0)
      }
      
    }
  
  }
  

  func axisMark(rect: CGRect, array: [Double]) {
    var actualDataScale = 0.0
    var windowCount = 0.0
    var frameScale = 0.0
    var scaleValue = 0.0
    let pointIncrement = Double(rect.size.width - 62) / Double(array.count)
    
    
    if let max = array.max() {
      let maxValue = max + 41
      
      //This is a good way to scale the data point to the graph view. Keep this.
      scaleValue = (Double(rect.size.height - 41) / maxValue)

      
      actualDataScale =  max / 6
      
      windowCount = 6

      frameScale = (Double(rect.size.height - 41) / 6)
      
    }
    
    
    for i in 0...Int(windowCount) {

      let yLabelTest = axisLabel(name: String(i * Int(actualDataScale)))
      yLabelTest.frame = CGRect(x: 0, y: Double(rect.size.height - 36) - (frameScale * Double(i)), width: 20, height: 20)
    
      addSubview(yLabelTest)
      
    }
    
    
    for i in 0...array.count - 1 {
      let xValue = calculatexValue(pointIncrement: pointIncrement, i: i, sideMargin: 41.0)
      
      let xLabelTest = axisLabel(name: String(i + 1))
      xLabelTest.frame = CGRect(x: xValue, y: Double(rect.size.height) - 20, width: 20, height: 20)
      addSubview(xLabelTest)
    }
    
  }
  


  
  func axisLabel(name: String) -> UILabel {
    let label = UILabel(frame: CGRect.zero)
    label.text = name
    label.font = UIFont.systemFont(ofSize: 8)
    label.textColor = UIColor.black
    label.backgroundColor = backgroundColor
    label.textAlignment = NSTextAlignment.left
    
    return label
  }

  
  
}




