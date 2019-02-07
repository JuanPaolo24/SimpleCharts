//
//  LineChartDataSet.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 06/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LineChartData {
  
  public let arrayAccess: [Double]
  public var circleEnabled = true
  public var lineEnabled = true
  
  public init(array: [Double]) {
    self.arrayAccess = array
  }
  
  func plotPoints(context: CGContext, rect: CGRect) {
    let connection = CGMutablePath()
    let yAxisPadding = Double(rect.size.height - 41)
    let arrayCount = Double(arrayAccess.count)
    let pointIncrement = Double(rect.size.width - 62) / arrayCount
    var maxValue = 0.0
    
    
    if let max = arrayAccess.max() {
      maxValue = max + 41
      if let firstValue = arrayAccess.first {
        let yValue = (yAxisPadding / maxValue) * firstValue
        
        connection.move(to: CGPoint(x: calculatexValue(pointIncrement: pointIncrement, distanceIncrement: 0, sideMargin: 41.0), y: yAxisPadding - yValue))
      }
    }
    
    for (i, value) in arrayAccess.enumerated() {
      
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
  
  
}
