//
//  HighlightRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 19/04/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

open class HighlightRenderer: UIView {
  
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func horizontalBarHighlightValues(context: CGContext, array: [[Double]], maxValue: Double, minValue: Double, arrayCount: Double, offSet: offset, touchPoint: CGPoint) {
    
    let height = Double(frame.size.height)
    let width = Double(frame.size.width)
    
    var calc = BarGraphCalculation(frameHeight: height, frameWidth: width, maxValue: maxValue, minValue: minValue, arrayCount: Double(array.count), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
    
    var highlightValueArray: [CGRect] = []
    let helper = HelperFunctions()
    
    for i in 0...(array.count - 1) {
      for (j, value) in array[i].enumerated() {
        calc = BarGraphCalculation(frameHeight: height, frameWidth: width, maxValue: maxValue, minValue: minValue, arrayCount: Double(array[i].count), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
        
        let yValue = calc.yHorizontalValue(i: j, dataSetCount: Double(i), count: arrayCount)
        let xValue = calc.xHorizontalValue()
        let width = calc.horizontalWidth(value: value)
        let height = calc.horizontalHeight(count: arrayCount)
        
        highlightValueArray.append(CGRect(x: xValue, y: yValue, width: width, height: height))
      }
      
    }
    
    let sortedXPoint = helper.combineCGRectHorizontalArray(array: highlightValueArray)
    let newXPoint = helper.findClosestHorizontal(array: sortedXPoint, target: touchPoint)
    print(sortedXPoint)
    context.protectGState {
      context.setFillColor(UIColor(red:0.24, green:0.24, blue:0.24, alpha:0.5).cgColor)
      context.setStrokeColor(UIColor(red:0.24, green:0.24, blue:0.24, alpha:0.5).cgColor)
      context.setLineWidth(1.0)
      context.addRect(newXPoint)
      context.drawPath(using: .fillStroke)
    }
  }
  
  
  func barHighlightValues(context: CGContext, array: [[Double]], maxValue: Double, minValue: Double, arrayCount: Double, offSet: offset, touchPoint: CGPoint) {
    let frameheight = Double(frame.size.height)
    let framewidth = Double(frame.size.width)
    
    var calc = BarGraphCalculation(frameHeight: frameheight, frameWidth: framewidth, maxValue: maxValue, minValue: minValue, arrayCount: Double(array.count), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
    
    var highlightValueArray: [CGRect] = []
    let helper = HelperFunctions()
    var width = 0.0
    var height = 0.0
    var xValue = 0.0
    
    
    for i in 0...(array.count - 1) {
      for (j, value) in array[i].enumerated() {
        calc = BarGraphCalculation(frameHeight: frameheight, frameWidth: framewidth, maxValue: maxValue, minValue: minValue, arrayCount: Double(array[i].count), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
        
        
        width = calc.verticalWidth(count: arrayCount)
        xValue = calc.xVerticalValue(i: j, dataSetCount: Double(i), count: arrayCount)
        let yValue = calc.yVerticalValue(value: value)
        
        height = calc.verticalHeight(value: value)
        highlightValueArray.append(CGRect(x: xValue, y: yValue, width: width, height: height))
      }
      
    }
    
    //create a function that accepts cg rect
    let sortedXPoint = helper.combineCGRectArray(array: highlightValueArray)
    let newXPoint = helper.findClosestY(array: sortedXPoint, target: touchPoint)
    context.protectGState {
      context.setFillColor(UIColor(red:0.24, green:0.24, blue:0.24, alpha:0.5).cgColor)
      context.setStrokeColor(UIColor(red:0.24, green:0.24, blue:0.24, alpha:0.5).cgColor)
      context.setLineWidth(1.0)
      context.addRect(newXPoint)
      context.drawPath(using: .fillStroke)
    }
    
    
  }
  
  
  func highlightValues(context: CGContext, array: [[Double]], touchPoint: CGPoint, maxValue: Double, minValue: Double, offSet: offset) {
    let helper = HelperFunctions()
    
    let height = Double(frame.size.height)
    let width = Double(frame.size.width)
    
    var calc = LineGraphCalculation(array: [], arrayCount: 0, maxValue: maxValue, minValue: minValue, frameWidth: width, frameHeight: height, offSet: offSet, yAxisGridlineCount: 0, xAxisGridlineCount: 0)
    
    var highlightValueArray: [CGPoint] = []
    
    var originalValueArray: [CGPoint] = []
    
    
    for i in 0...(array.count - 1) {
      calc = LineGraphCalculation(array: array[i], arrayCount: 0, maxValue: maxValue, minValue: minValue, frameWidth: width, frameHeight: height, offSet: offSet, yAxisGridlineCount: 0, xAxisGridlineCount: 0)
      for (i,value) in array[i].enumerated() {
        let xValue = calc.xlineGraphPoint(i: i)
        let yValue = calc.ylineGraphPoint(value: value)
        highlightValueArray.append(CGPoint(x: xValue, y: yValue))
        originalValueArray.append(CGPoint(x: xValue, y: value))
      }
    }
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    
    let attributes: [NSAttributedString.Key : Any] = [
      .paragraphStyle: paragraphStyle,
      .font: UIFont.systemFont(ofSize: 12),
      .foregroundColor: UIColor.black,
      .backgroundColor: UIColor.gray
    ]
    
    
    let sortedXPoint = helper.combineCGPointArray(array: highlightValueArray)
    let newXPoint = helper.findClosest(array: sortedXPoint, target: touchPoint)
    let sortedOriginalPoint = helper.combineCGPointArray(array: originalValueArray)
    let originalPoint = helper.findClosest(array: sortedOriginalPoint, target: touchPoint)
    
    
    
    let attributedString = NSAttributedString(string: "\(originalPoint.y)", attributes: attributes)
    attributedString.draw(in: CGRect(x: newXPoint.x - 20, y: newXPoint.y - 25, width: 50, height: 40))
    
    context.protectGState {
      let gridLine = CGMutablePath()
      gridLine.move(to: CGPoint(x: newXPoint.x, y: 20))
      gridLine.addLine(to: CGPoint(x: newXPoint.x, y: frame.size.height - 62))
      let anotherGridline = CGMutablePath()
      anotherGridline.move(to: CGPoint(x: 32, y: newXPoint.y))
      anotherGridline.addLine(to: CGPoint(x: frame.size.width - 32, y: newXPoint.y))
      context.addPath(gridLine)
      context.addPath(anotherGridline)
      context.setStrokeColor(UIColor(red:0.95, green:0.87, blue:0.76, alpha:1.0).cgColor)
      context.strokePath()
      context.setLineWidth(0.5)
      context.setLineDash(phase: 0, lengths: [1])
    }
    
    
  }
  
}
