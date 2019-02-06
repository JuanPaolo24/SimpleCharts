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
    
    let valuetest: [Double] = [130, 55, 100, 50, 120]
    
    
    
    plotPoints(context: context, rect: rect, array: valuetest, circleEnabled: true, lineEnabled: true)
    drawAxis(context: context, rect: rect)
    drawAxisGridLines(context: context, rect: rect, array: valuetest, isEnabled: true)
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
    let yAxisPadding = Double(rect.size.height - 41)
    let arrayCount = Double(array.count)
    let pointIncrement = Double(rect.size.width - 62) / arrayCount
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
      
      
      if circleEnabled == true {
        drawCirclePoints(context: context, xValue: xValue, yValue: yValue, radius: 3, lineWidth: 1.0, colour: UIColor.black.cgColor)
      }
      
      if lineEnabled == true {
        drawLines(context: context, connection: connection, xValue: xValue, yValue: yValue, lineWidth: 1.0, colour: UIColor.black.cgColor)
      }
    }
  }
  
  
  //Ensures that there is sufficient padding at the start and end of the x axis
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
  
  
  
  func drawCirclePoints(context: CGContext, xValue: Double, yValue: Double, radius: CGFloat, lineWidth: CGFloat, colour: CGColor) {
    context.addArc(center: CGPoint(x: xValue, y: yValue), radius: radius, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
    context.setLineWidth(lineWidth)
    context.setFillColor(colour)
    context.fillPath()
    
  }
  
  
  func drawLines(context: CGContext, connection: CGMutablePath, xValue: Double, yValue: Double, lineWidth: CGFloat, colour: CGColor) {
    connection.addLine(to: CGPoint(x: xValue, y: yValue))
    context.addPath(connection)
    context.setStrokeColor(colour)
    context.strokePath()
    context.setLineWidth(lineWidth)
  }
  
  
  
  
  func drawAxisGridLines(context: CGContext, rect: CGRect, array: [Double], isEnabled: Bool) {
    let numberofGridlines = 6
    let frameScale = (Double(rect.size.height - 41) / 6)
    let pointIncrement = Double(rect.size.width - 62) / Double(array.count)
    
    if isEnabled == true {
      for i in 0...numberofGridlines {
      
        let secondGridLine = CGMutablePath()
        secondGridLine.move(to: CGPoint(x: 30, y: Double(rect.size.height - 31) - (frameScale * Double(i))))
        secondGridLine.addLine(to: CGPoint(x: Double(rect.size.width - 31), y: Double(rect.size.height - 31) - (frameScale * Double(i))))
        
        context.addPath(secondGridLine)
        context.setStrokeColor(UIColor.black.cgColor)
        context.strokePath()
        context.setLineWidth(1.0)
      }
      
      for i in 0...array.count - 1 {
        
        let xValue = calculatexValue(pointIncrement: pointIncrement, distanceIncrement: i, sideMargin: 41.0)
        
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
    let numberofGridlines = 6
    var frameScale = 0.0
    let pointIncrement = Double(rect.size.width - 62) / Double(array.count)
    
    
    if let max = array.max() {
      actualDataScale =  max / 6

      frameScale = (Double(rect.size.height - 41) / 6)
      
    }
    
    for i in 0...numberofGridlines {
      let yLabelTest = axisLabel(name: String(i * Int(actualDataScale)))
      yLabelTest.frame = CGRect(x: 0, y: Double(rect.size.height - 36) - (frameScale * Double(i)), width: 20, height: 20)
    
      addSubview(yLabelTest)
    }
    
    for i in 0...array.count - 1 {
      let xValue = calculatexValue(pointIncrement: pointIncrement, distanceIncrement: i, sideMargin: 41.0)
      
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




