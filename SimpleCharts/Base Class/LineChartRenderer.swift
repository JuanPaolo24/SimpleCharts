//
//  LineChartRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 19/04/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation
import CoreGraphics

open class LineChartRenderer: ChartRenderer {
  
  var sourceData = LineChartData()
  let helper = HelperFunctions()

  
  func addGradient(to context: CGContext, using array: [Double], offSet: offset) {
    let gradientPath = CGMutablePath()
    gradientPath.move(to: CGPoint(x: offSet.left, y: frameHeight() - offSet.bottom))
    let gradientFillPath = CGMutablePath()
    gradientFillPath.move(to: CGPoint(x: calculate.xlineGraphPoint(for: .singleChart, from: 0), y: frameHeight() - offSet.bottom))
    
    var xValue = 0.0
    
    var yValueArray: [Double] = []
    
    for (increment, value) in array.enumerated() {
      
      xValue = calculate.xlineGraphPoint(for: .singleChart, from: increment)
      let yValue = calculate.ylineGraphPoint(from: value)
      
      gradientFillPath.addLine(to: CGPoint(x: xValue, y: yValue))
      gradientPath.addLine(to: CGPoint(x: xValue, y: yValue))
      yValueArray.append(yValue)
    }
    guard let minimum = yValueArray.min() else { return }
    
    let gradientStartPoint = CGPoint(x: offSet.left, y: minimum)
    let gradientEndPoint = CGPoint(x: offSet.left, y: frameHeight() - offSet.bottom)
    
    if sourceData.enableGraphFill == true {
      switch sourceData.fillType {
      case.gradientFill:
        context.protectGState {
          gradientPath.addLine(to: CGPoint(x: frameWidth() - offSet.right, y: frameHeight() - offSet.bottom))
          gradientPath.closeSubpath()
          context.addPath(gradientPath)
          context.clip()
          let colorComponents = helper.createColourStructure(from: sourceData.gradientFillColors)
          
          let locations:[CGFloat] = [0.0, 1.0]
          
          guard let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB() ,colorComponents: colorComponents,locations: locations, count: locations.count) else { return }
          context.setAlpha(0.33)
          context.drawLinearGradient(gradient, start: gradientStartPoint, end: gradientEndPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        }
      case.normalFill:
        context.protectGState {
          gradientFillPath.addLine(to: CGPoint(x: xValue, y: frameHeight() - offSet.bottom))
          context.setStrokeColor(UIColor.clear.cgColor)
          context.strokePath()
          context.setLineWidth(3)
          context.beginPath()
          context.addPath(gradientFillPath)
          context.setFillColor(sourceData.setGraphFill.cgColor)
          context.setAlpha(sourceData.setFillAlpha)
          context.fillPath()
        }
      }
    }
  }
  
  func addBezierGradient(to context: CGContext, using array: [Double], offSet: offset) {
    
    let startingYValue = calculate.ylineGraphStartPoint()
    let startingXValue = calculate.xlineGraphPoint(for: .singleChart, from: 0)
    
    let gradientPath = CGMutablePath()
    gradientPath.move(to: CGPoint(x: offSet.left, y: frameHeight() - offSet.bottom))
    gradientPath.addLine(to: CGPoint(x: offSet.left, y: startingYValue))
    let gradientFillPath = CGMutablePath()
    gradientFillPath.move(to: CGPoint(x: startingXValue, y: frameHeight() - offSet.bottom))
    gradientFillPath.addLine(to: CGPoint(x: offSet.left, y: startingYValue))
    
    var destination = CGPoint()
    
    var yValueArray: [Double] = []
    yValueArray.append(startingYValue)
    
    let index = Array(array.dropFirst())
    
    for (increment, value) in index.enumerated() {
      
      destination = calculate.bezierGraphPoint(for: .singleChart, from: increment, and: value)
      let control1 = calculate.bezierControlPoint(1, for: .singleChart, from: increment, and: value, with: sourceData.setBezierCurveIntensity)
      let control2 = calculate.bezierControlPoint(2, for: .singleChart, from: increment, and: value, with: sourceData.setBezierCurveIntensity)
      
      gradientFillPath.addCurve(to: destination, control1: control1, control2: control2)
      context.addPath(gradientFillPath)
      context.setStrokeColor(UIColor.clear.cgColor)
      context.strokePath()
      
      gradientPath.addCurve(to: destination, control1: control1, control2: control2)
      
      yValueArray.append(Double(destination.y))
    }
    
    guard let minimum = yValueArray.min() else { return }
    
    let gradientStartPoint = CGPoint(x: offSet.left, y: minimum)
    let gradientEndPoint = CGPoint(x: offSet.left, y: frameHeight() - offSet.bottom)
    
    if sourceData.enableGraphFill == true {
      switch sourceData.fillType {
      case.gradientFill:
        context.protectGState {
          gradientPath.addLine(to: CGPoint(x: frameWidth() - offSet.right, y: frameHeight() - offSet.bottom))
          gradientPath.closeSubpath()
          context.addPath(gradientPath)
          context.clip()
          
          let colorComponents = helper.createColourStructure(from: sourceData.gradientFillColors)
          
          let locations:[CGFloat] = [0.0, 1.0]
          
          guard let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB() ,colorComponents: colorComponents,locations: locations, count: locations.count) else { return }
          context.setAlpha(0.33)
          context.drawLinearGradient(gradient, start: gradientStartPoint, end: gradientEndPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        }
      case.normalFill:
        context.protectGState {
          gradientFillPath.addLine(to: CGPoint(x: Double(destination.x), y: frameHeight() - offSet.bottom))
          context.setStrokeColor(UIColor.clear.cgColor)
          context.strokePath()
          context.setLineWidth(3)
          context.beginPath()
          context.addPath(gradientFillPath)
          context.setFillColor(sourceData.setGraphFill.cgColor)
          context.setAlpha(sourceData.setFillAlpha)
          context.fillPath()
        }
      }
    }
    
  }
  
  
  func addCircles(to context: CGContext, from array: [Double], for type: chartType) {
    for (increment, value) in array.enumerated() {
      
      let xValue = calculate.xlineGraphPoint(for: type, from: increment)
      let yValue = calculate.ylineGraphPoint(from: value)
      
      if sourceData.enableCirclePointVisibility == true {
        context.addArc(center: CGPoint(x: xValue, y: yValue), radius: sourceData.setCirclePointRadius, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
        context.setFillColor(sourceData.setLineGraphColor.cgColor)
        context.fillPath()
      }
    }
  }
  
  
  /// Base function for drawing single line graphs. Requires context, the array to be plotted and the max value of the whole data set
  func addLine(to context: CGContext, from array: [Double], for type: chartType) {
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: sourceData.setTextLabelFontSize), foreGroundColor: sourceData.setTextLabelColor)
    
    let startingYValue = calculate.ylineGraphStartPoint()
    let startingXValue = calculate.xlineGraphPoint(for: type, from: 0)
    
    let linePath = CGMutablePath()
    linePath.move(to: CGPoint(x: startingXValue, y: startingYValue))
    
    for (increment, value) in array.enumerated() {
      
      let xValue = calculate.xlineGraphPoint(for: type, from: increment)
      let yValue = calculate.ylineGraphPoint(from: value)
      
      if sourceData.enableLineVisibility == true {
        context.protectGState {
          linePath.addLine(to: CGPoint(x: xValue, y: yValue))
          context.addPath(linePath)
          context.setStrokeColor(sourceData.setLineGraphColor.cgColor)
          context.strokePath()
          context.setLineWidth(sourceData.setLineWidth)
        }
      }
      
      if sourceData.enableDataPointLabel == true {
        textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: xValue, y: yValue - 20, width: 40, height: 20))
      }
    }
  }
  
  

  
  
  /// Base function for drawing line graphs with bezier curve. Requires context, the array to be plotted and the max value of the whole data set
  func addBezierLine(to context: CGContext, from array: [Double], for type: chartType) {
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: sourceData.setTextLabelFontSize), foreGroundColor: sourceData.setTextLabelColor)
    
    let startingYValue = calculate.ylineGraphStartPoint()
    let startingXValue = calculate.xlineGraphPoint(for: type, from: 0)
    
    let path = CGMutablePath()
    path.move(to: CGPoint(x: startingXValue, y: startingYValue))

    let index = Array(array.dropFirst())
    
    for (increment, value) in index.enumerated() {

        let destination = calculate.bezierGraphPoint(for: type, from: increment, and: value)
        let control1 = calculate.bezierControlPoint(1, for: type, from: increment, and: value, with: sourceData.setBezierCurveIntensity)
        let control2 = calculate.bezierControlPoint(2, for: type, from: increment, and: value, with: sourceData.setBezierCurveIntensity)

      
      if sourceData.enableLineVisibility == true {
        path.addCurve(to: destination, control1: control1, control2: control2)
        context.addPath(path)
        context.setStrokeColor(sourceData.setLineGraphColor.cgColor)
        context.strokePath()
      }

      if sourceData.enableDataPointLabel == true {
        textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: destination.x, y: destination.y - 15, width: 40, height: 20))
      }
    }
  }
  
  func highlightValues(in context: CGContext, using array: [[Double]], and touchPoint: CGPoint, with maxValue: Double, _ minValue: Double, _ offSet: offset) {
    let helper = HelperFunctions()
    var highlightValueArray: [CGPoint] = []
    var originalValueArray: [CGPoint] = []
    let height = Double(frame.size.height)
    let width = Double(frame.size.width)
    var calc = GraphCalculation()
    
    for i in 0...(array.count - 1) {
      for (increment,value) in array[i].enumerated() {
        calc = GraphCalculation(array: array[i], maxValue: maxValue, minValue: minValue, frameWidth: width, frameHeight: height, offSet: offSet)
        //Having its own instance is better for performance
        let xValue = calc.xlineGraphPoint(for: .singleChart, from: increment)
        let yValue = calc.ylineGraphPoint(from: value)
        highlightValueArray.append(CGPoint(x: xValue, y: yValue))
        originalValueArray.append(CGPoint(x: xValue, y: value))
      }
    }
    
    let sortedXPointArray = helper.combineCGPoint(Array: highlightValueArray)
    let newXPoint = helper.returnClosestPoint(from: sortedXPointArray, using: touchPoint)
    let sortedOriginalPointArray = helper.combineCGPoint(Array: originalValueArray)
    let originalPoint = helper.returnClosestPoint(from: sortedOriginalPointArray, using: touchPoint)
    
    let textFrame = CGRect(x: newXPoint.x - 20, y: newXPoint.y - 25, width: 50, height: 40)
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: 12), foreGroundColor: UIColor.black, backGroundColor: UIColor.gray)
    textRenderer.renderText(text: "\(originalPoint.y)", textFrame: textFrame)
    
    context.protectGState {
      let gridLine = CGMutablePath()
      gridLine.move(to: CGPoint(x: newXPoint.x, y: CGFloat(offSet.top)))
      gridLine.addLine(to: CGPoint(x: newXPoint.x, y: CGFloat(height - offSet.bottom)))
      let anotherGridline = CGMutablePath()
      anotherGridline.move(to: CGPoint(x: CGFloat(offSet.left), y: newXPoint.y))
      anotherGridline.addLine(to: CGPoint(x: CGFloat(width - offSet.right), y: newXPoint.y))
      context.addPath(gridLine)
      context.addPath(anotherGridline)
      context.setStrokeColor(UIColor(red:0.95, green:0.87, blue:0.76, alpha:1.0).cgColor)
      context.strokePath()
      context.setLineWidth(0.5)
      context.setLineDash(phase: 0, lengths: [1])
    }
    
    
  }
  
  
}
