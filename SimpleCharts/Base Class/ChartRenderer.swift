//
//  ChartRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 07/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation
import CoreGraphics


open class ChartRenderer: UIView {
  
  public var gridlinesEnable = true
  public var context: CGContext
  public var rect: CGContext
  public var array: [Double]
  
  public init(frame: CGRect, context: CGContext, rect: CGContext, array: [Double]) {
    self.context = context
    self.rect = rect
    self.array = array
    
    super.init(frame: frame)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard let context = UIGraphicsGetCurrentContext() else {
      print("could not get context")
      return
    }
  
  func yAxis() {
    let frameScale = (Double(rect.size.height - 41) / 6)
    var actualDataScale = 0.0
    let numberofGridlines = 6
    let yAxisPadding = rect.size.height - 31
    let xAxisPadding = rect.size.width - 62
    
    if let max = array.max() {
      actualDataScale =  max / 6
    }
    
    let yAxisPath = CGMutablePath()
    yAxisPath.move(to: CGPoint(x: 30, y: 10))
    yAxisPath.addLine(to: CGPoint(x: 30, y: yAxisPadding))
    context.addPath(yAxisPath)
    context.setLineWidth(3.0)
    context.setStrokeColor(UIColor.black.cgColor)
    context.strokePath()
    
    for i in 0...numberofGridlines {
      
      let yGridLine = CGMutablePath()
      yGridLine.move(to: CGPoint(x: 30, y: Double(yAxisPadding) - (frameScale * Double(i))))
      yGridLine.addLine(to: CGPoint(x: Double(xAxisPadding), y: Double(yAxisPadding) - (frameScale * Double(i))))
      
      context.addPath(yGridLine)
      context.setStrokeColor(UIColor.black.cgColor)
      context.strokePath()
      //context.setLineWidth(1.0)
      context.setLineDash(phase: 0, lengths: [1])
      
      
      let yLabelTest = axisLabel(name: String(i * Int(actualDataScale)))
      yLabelTest.frame = CGRect(x: 0, y: Double(rect.size.height - 36) - (frameScale * Double(i)), width: 20, height: 20)
      
      addSubview(yLabelTest)
    }
  }
    
    func xAxis() {
      let yAxisPadding = rect.size.height - 31
      let xAxisPadding = rect.size.width - 62
      let pointIncrement = Double(rect.size.width - 62) / Double(array.count)
      
      let xAxisPath = CGMutablePath()
      xAxisPath.move(to: CGPoint(x: 30, y: yAxisPadding))
      xAxisPath.addLine(to: CGPoint(x: xAxisPadding, y: yAxisPadding))
      context.addPath(xAxisPath)
      context.setLineWidth(3.0)
      context.setStrokeColor(UIColor.black.cgColor)
      context.strokePath()
      
      for i in 0...array.count - 1 {
        
        let xValue = calculatexValue(pointIncrement: pointIncrement, distanceIncrement: i, sideMargin: 41.0)
        
        let firstGridLine = CGMutablePath()
        firstGridLine.move(to: CGPoint(x: xValue, y: 10))
        firstGridLine.addLine(to: CGPoint(x: xValue, y: Double(yAxisPadding)))
        context.addPath(firstGridLine)
        
        context.setStrokeColor(UIColor.black.cgColor)
        context.strokePath()
        //context.setLineWidth(1.0)
        context.setLineDash(phase: 0, lengths: [1])
        
      
        
        let xLabelTest = axisLabel(name: String(i + 1))
        xLabelTest.frame = CGRect(x: xValue, y: Double(rect.size.height) - 28, width: 20, height: 20)
        addSubview(xLabelTest)
      }
    }
  
  
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
  
}
}
