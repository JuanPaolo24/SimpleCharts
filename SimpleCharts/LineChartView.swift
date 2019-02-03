//
//  LineChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 25/01/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation
import CoreGraphics


//TODO: Add in the labels
//TODO: Clean up code and conform to swift guidelines
//TODO: Eventually modulise the code so that it resembles a library
//TODO: Value formatter which will allow any type of number value to be inputted
//TODO: Also add in the customisation
//TODO: Start creating the test case so that it will be used instead of manually running the graph everytime


//Current status: It is creating points dynamically but most of the code is still hardcoded


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
    
    let valuetest: [Double] = [1, 2, 100, 50, 120, 200, 300, 200, 123, 100]
    
    plotPoints(context: context, rect: rect, array: valuetest, circleEnabled: true, lineEnabled: false)
    drawAxis(context: context, rect: rect)
    
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
    let yAxisPadding = rect.size.height - 31
    let arrayCount = Double(array.count)
    let pointIncrement = Double(rect.size.width - 62) / arrayCount
    let sideMargin = 41.0
    var marker = 0.0
    var xValue = 0.0
    var firstPoint = 0.0
    var maxValue = 0.0
    
    if let max = array.max() {
      maxValue = max + 50
      if let firstValue = array.first {
        firstPoint = (Double(yAxisPadding) / max) * firstValue
      }
    }
    
    connection.move(to: CGPoint(x: Double(pointIncrement + 31), y: Double(yAxisPadding) - firstPoint))
    
    for (i, value) in array.enumerated() {
      
      if pointIncrement > sideMargin {
        marker = pointIncrement - sideMargin
        xValue = Double((pointIncrement * (Double(i) + 1.0)) - marker)
      } else {
        marker = sideMargin - pointIncrement
        xValue = Double((pointIncrement * (Double(i) + 1.0)) + marker)
      }
      
      let yValue = (Double(yAxisPadding) / maxValue) * value
      
      
      if circleEnabled == true {
        drawCirclePoints(context: context, xValue: xValue, yValue: yValue, yAxisPadding: yAxisPadding, radius: 3, lineWidth: 1.0, colour: UIColor.black.cgColor)
      }
      
      if lineEnabled == true {
        drawLines(context: context, connection: connection, xValue: xValue, yValue: yValue, yAxisPadding: yAxisPadding, lineWidth: 1.0, colour: UIColor.black.cgColor)
      }
    }
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
  
  
  
  
  //The problem with the label is that it is currently just adding a UI label to the sub view.
  //This causes it to not line up with the CGPaths
  
  func axisGridLines(context: CGContext, rect: CGRect, isGridline: Bool) {
    
    if isGridline == true {
      for i in 1...8 {
        let firstGridLine = CGMutablePath()
        firstGridLine.move(to: CGPoint(x: Double(40 * (i + 1)), y: 10))
        firstGridLine.addLine(to: CGPoint(x: Double(40 * (i + 1)), y: Double(rect.size.height - 31)))
        context.addPath(firstGridLine)
        let secondGridLine = CGMutablePath()
        secondGridLine.move(to: CGPoint(x: 30, y: Int(rect.size.height) - (30 * i)))
        secondGridLine.addLine(to: CGPoint(x: Int(rect.size.width - 31), y: Int(rect.size.height) - (30 * i)))
        
        
        context.addPath(secondGridLine)
        context.setStrokeColor(UIColor.black.cgColor)
        context.strokePath()
        context.setLineWidth(1.0)
        
      }
    }
  
  }
  

  func axisMark(rect: CGRect, array: [Double]) {
    
    let valueIncrement = array.max()! / 8
    
    for i in 1...8 {
      
      let yLabelTest = axisLabel(name: String(i * Int(valueIncrement)))
      yLabelTest.frame = CGRect(x: 5, y: Int(rect.size.height) - (30 * i), width: 20, height: 20)
      
      let xLabelTest = axisLabel(name: "Mon")
      xLabelTest.frame = CGRect(x: 50 * i, y: Int(rect.size.height) - 20, width: 60, height: 20)
      
      addSubview(yLabelTest)
      addSubview(xLabelTest)
      
    }
    
  }
  


  
  func axisLabel(name: String) -> UILabel {
    let label = UILabel(frame: CGRect.zero)
    label.text = name
    label.font = UIFont.boldSystemFont(ofSize: 10)
    label.textColor = UIColor.black
    label.backgroundColor = backgroundColor
    label.textAlignment = NSTextAlignment.center
    
    return label
  }

  
  
}




