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
  
  public let axisAccess: LineChartAxis
  public let dataAccess: LineChartData
  public var gridlinesEnable = true
  
  public init(frame: CGRect, axis: LineChartAxis, data: LineChartData) {
    self.axisAccess = axis
    self.dataAccess = data
    
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
    
  
    axisAccess.drawAxis(context: context, rect: rect)
    axisAccess.axisMark(rect: rect, view: self)
    dataAccess.plotPoints(context: context, rect: rect)
    drawAxisGridLines(context: context, rect: rect, array: dataAccess.arrayAccess)
    
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
  

  
  func drawAxisGridLines(context: CGContext, rect: CGRect, array: [Double]) {
    let numberofGridlines = 6
    let frameScale = (Double(rect.size.height - 41) / 6)
    let pointIncrement = Double(rect.size.width - 62) / Double(array.count)
    
    if gridlinesEnable == true {
      for i in 0...numberofGridlines {
      
        let secondGridLine = CGMutablePath()
        secondGridLine.move(to: CGPoint(x: 30, y: Double(rect.size.height - 31) - (frameScale * Double(i))))
        secondGridLine.addLine(to: CGPoint(x: Double(rect.size.width - 31), y: Double(rect.size.height - 31) - (frameScale * Double(i))))
        
        context.addPath(secondGridLine)
        context.setStrokeColor(UIColor.black.cgColor)
        context.strokePath()
        //context.setLineWidth(1.0)
        context.setLineDash(phase: 0, lengths: [1])
      }
      
      for i in 0...array.count - 1 {
        
        let xValue = calculatexValue(pointIncrement: pointIncrement, distanceIncrement: i, sideMargin: 41.0)
        
        let firstGridLine = CGMutablePath()
        firstGridLine.move(to: CGPoint(x: xValue, y: 10))
        firstGridLine.addLine(to: CGPoint(x: xValue, y: Double(rect.size.height - 31)))
        context.addPath(firstGridLine)
        
        context.setStrokeColor(UIColor.black.cgColor)
        context.strokePath()
        //context.setLineWidth(1.0)
        context.setLineDash(phase: 0, lengths: [1])
      }
    }
  }
  
  
}




