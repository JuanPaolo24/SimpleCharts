//
//  LineChartAxis.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 06/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LineChartAxis {
  
  
  public let arrayAccess: [Double]
  
  public init(array: [Double]) {
    self.arrayAccess = array
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
  
  
  func axisMark(rect: CGRect, view: UIView) {
    var actualDataScale = 0.0
    let numberofGridlines = 6
    var frameScale = 0.0
    let pointIncrement = Double(rect.size.width - 62) / Double(arrayAccess.count)
    
    
    if let max = arrayAccess.max() {
      actualDataScale =  max / 6
      
      frameScale = (Double(rect.size.height - 41) / 6)
      
    }
    
    for i in 0...numberofGridlines {
      let yLabelTest = axisLabel(name: String(i * Int(actualDataScale)))
      yLabelTest.frame = CGRect(x: 0, y: Double(rect.size.height - 36) - (frameScale * Double(i)), width: 20, height: 20)
      
      view.addSubview(yLabelTest)
    }
    
    for i in 0...arrayAccess.count - 1 {
      let xValue = calculatexValue(pointIncrement: pointIncrement, distanceIncrement: i, sideMargin: 41.0)
      
      let xLabelTest = axisLabel(name: String(i + 1))
      xLabelTest.frame = CGRect(x: xValue, y: Double(rect.size.height) - 20, width: 20, height: 20)
      view.addSubview(xLabelTest)
    }
    
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
  
}
