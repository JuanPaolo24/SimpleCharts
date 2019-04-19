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
  
  
  func addGradient(context: CGContext, path: CGMutablePath, endLine: CGPoint, gradientStart: CGPoint, gradientEnd: CGPoint, source: LineChartData) {
    context.protectGState {
      path.addLine(to: endLine)
      path.closeSubpath()
      context.addPath(path)
      
      context.clip()
      
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      
      var colorComponents: [CGFloat] = []
      
      for colours in source.gradientFillColours {
        
        guard let components = colours.cgColor.components else { return }
        colorComponents.append(components[0])
        colorComponents.append(components[1])
        colorComponents.append(components[2])
        colorComponents.append(components[3])
      }
      
      let locations:[CGFloat] = [0.0, 1.0]
      
      guard let gradient = CGGradient(colorSpace: colorSpace,colorComponents: colorComponents,locations: locations, count: locations.count) else { return }
      context.setAlpha(0.33)
      context.drawLinearGradient(gradient, start: gradientStart, end: gradientEnd, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
    }
  }
  
  
  func addGradientPath(context: CGContext, array: [Double], maxValue: Double, minValue: Double, source: LineChartData, offSet: offset, xGridlineCount: Double, yGridlineCount: Double) {
    let calc = LineGraphCalculation(array: array, arrayCount: 0, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yGridlineCount, xAxisGridlineCount: xGridlineCount)
    
    let startingXValue = calc.xlineGraphPoint(i: 0)
    
    let gradientPath = CGMutablePath()
    gradientPath.move(to: CGPoint(x: offSet.left, y: frameHeight() - offSet.bottom))
    let gradientFillPath = CGMutablePath()
    gradientFillPath.move(to: CGPoint(x: startingXValue, y: frameHeight() - offSet.bottom))
    
    var xValue = 0.0
    var yValue = 0.0
    
    var smallVal: [Double] = []
    for (i, value) in array.enumerated() {
      
      xValue = calc.xlineGraphPoint(i: i)
      yValue = calc.ylineGraphPoint(value: value)
      
      gradientFillPath.addLine(to: CGPoint(x: xValue, y: yValue))
      gradientPath.addLine(to: CGPoint(x: xValue, y: yValue))
      smallVal.append(yValue)
    }
    
    guard let minimum = smallVal.min() else { return }
    
    let gradientStartPoint = CGPoint(x: offSet.left, y: minimum)
    let gradientEndPoint = CGPoint(x: offSet.left, y: frameHeight() - offSet.bottom)
    
    if source.enableGraphFill == true {
      switch source.fillType {
      case.gradientFill:
        addGradient(context: context, path: gradientPath, endLine: CGPoint(x: frameWidth() - offSet.right, y: frameHeight() - offSet.bottom), gradientStart: gradientStartPoint, gradientEnd: gradientEndPoint, source: source)
      case.normalFill:
        context.protectGState {
          gradientFillPath.addLine(to: CGPoint(x: xValue, y: frameHeight() - offSet.bottom))
          context.setStrokeColor(UIColor.clear.cgColor)
          context.strokePath()
          context.setLineWidth(3)
          context.beginPath()
          context.addPath(gradientFillPath)
          context.setFillColor(source.setGraphFill.cgColor)
          context.setAlpha(source.setFillAlpha)
          context.fillPath()
        }
      }
    }
  }
  
  func drawCircles(context: CGContext, array: [Double], maxValue: Double, minValue: Double, source: LineChartData, offSet: offset, xGridlineCount: Double, yGridlineCount: Double) {
    let calc = LineGraphCalculation(array: array, arrayCount: 0, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yGridlineCount, xAxisGridlineCount: xGridlineCount)
    
    for (i, value) in array.enumerated() {
      
      let xValue = calc.xlineGraphPoint(i: i)
      let yValue = calc.ylineGraphPoint(value: value)
      
      if source.enableCirclePointVisibility == true {
        context.addArc(center: CGPoint(x: xValue, y: yValue), radius: source.setCirclePointRadius, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
        context.setFillColor(source.setLineGraphColour)
        context.fillPath()
      }
    }
    
  }
  
  
  /// Base function for drawing single line graphs. Requires context, the array to be plotted and the max value of the whole data set
  func drawLine(context: CGContext, array: [Double], maxValue: Double, minValue: Double, source: LineChartData, offSet: offset, xGridlineCount: Double, yGridlineCount: Double) {
    let calc = LineGraphCalculation(array: array, arrayCount: 0, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yGridlineCount, xAxisGridlineCount: xGridlineCount)
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: source.setTextLabelFont), foreGroundColor: source.setTextLabelColour)
    
    let startingYValue = calc.ylineGraphStartPoint()
    let startingXValue = calc.xlineGraphPoint(i: 0)
    
    let linePath = CGMutablePath()
    linePath.move(to: CGPoint(x: startingXValue, y: startingYValue))
    
    for (i, value) in array.enumerated() {
      
      let xValue = calc.xlineGraphPoint(i: i)
      let yValue = calc.ylineGraphPoint(value: value)
      
      if source.enableLineVisibility == true {
        context.protectGState {
          linePath.addLine(to: CGPoint(x: xValue, y: yValue))
          context.addPath(linePath)
          context.setStrokeColor(source.setLineGraphColour)
          context.strokePath()
          context.setLineWidth(source.setLineWidth)
        }
      }
      
      if source.enableDataPointLabel == true {
        textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: xValue, y: yValue - 20, width: 40, height: 20))
      }
    }

  }
  
  
  func addBezierGradientPath(context: CGContext, array: [Double], maxValue: Double, minValue: Double, source: LineChartData, offSet: offset, xGridlineCount: Double, yGridlineCount: Double) {
    let calc = LineGraphCalculation(array: array, arrayCount: 0, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yGridlineCount, xAxisGridlineCount: xGridlineCount)
    
    let startingYValue = calc.ylineGraphStartPoint()
    let startingXValue = calc.xlineGraphPoint(i: 0)
    
    let gradientPath = CGMutablePath()
    gradientPath.move(to: CGPoint(x: offSet.left, y: frameHeight() - offSet.bottom))
    gradientPath.addLine(to: CGPoint(x: offSet.left, y: startingYValue))
    let gradientFillPath = CGMutablePath()
    gradientFillPath.move(to: CGPoint(x: startingXValue, y: frameHeight() - offSet.bottom))
    gradientFillPath.addLine(to: CGPoint(x: offSet.left, y: startingYValue))
    
    var destination = CGPoint()
    var control1 = CGPoint()
    var control2 = CGPoint()
    
    var smallVal: [Double] = []
    smallVal.append(startingYValue)
    
    let index = Array(array.dropFirst())
    
    for (i, value) in index.enumerated() {
      
      destination = calc.bezierGraphPoint(i: i, value: value)
      control1 = calc.bezierControlPoint(i: i, value: value, intensity: source.setBezierCurveIntensity, isControl1: true)
      control2 = calc.bezierControlPoint(i: i, value: value, intensity: source.setBezierCurveIntensity, isControl1: false)
      
      gradientFillPath.addCurve(to: destination, control1: control1, control2: control2)
      context.addPath(gradientFillPath)
      context.setStrokeColor(UIColor.clear.cgColor)
      context.strokePath()

      gradientPath.addCurve(to: destination, control1: control1, control2: control2)
      
      smallVal.append(Double(destination.y))
    }
    
    guard let minimum = smallVal.min() else { return }
    
    let gradientStartPoint = CGPoint(x: offSet.left, y: minimum)
    let gradientEndPoint = CGPoint(x: offSet.left, y: frameHeight() - offSet.bottom)
    
    if source.enableGraphFill == true {
      switch source.fillType {
      case.gradientFill:
        addGradient(context: context, path: gradientPath, endLine: CGPoint(x: frameWidth() - offSet.right, y: frameHeight() - offSet.bottom), gradientStart: gradientStartPoint, gradientEnd: gradientEndPoint, source: source)
      case.normalFill:
        context.protectGState {
          gradientFillPath.addLine(to: CGPoint(x: Double(destination.x), y: frameHeight() - offSet.bottom))
          context.setStrokeColor(UIColor.clear.cgColor)
          context.strokePath()
          context.setLineWidth(3)
          context.beginPath()
          context.addPath(gradientFillPath)
          context.setFillColor(source.setGraphFill.cgColor)
          context.setAlpha(source.setFillAlpha)
          context.fillPath()
        }
      }
    }
  
  }
  
  
  /// Base function for drawing line graphs with bezier curve. Requires context, the array to be plotted and the max value of the whole data set
  func drawBezierCurve(context: CGContext, array: [Double], maxValue: Double, minValue: Double, source: LineChartData, forCombined:Bool, offSet: offset, xGridlineCount: Double, yGridlineCount: Double) {
    let calc = LineGraphCalculation(array: array, arrayCount: 0, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yGridlineCount, xAxisGridlineCount: xGridlineCount)
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: source.setTextLabelFont), foreGroundColor: source.setTextLabelColour)
    
    let startingYValue = calc.ylineGraphStartPoint()
    var startingXValue = 0.0
    
    if forCombined == true {
      startingXValue = calc.xlineCombinePoint(i: 0)
    } else {
      startingXValue = calc.xlineGraphPoint(i: 0)
    }
    
    let path = CGMutablePath()
    path.move(to: CGPoint(x: startingXValue, y: startingYValue))
  
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
        path.addCurve(to: destination, control1: control1, control2: control2)
        context.addPath(path)
        context.setStrokeColor(source.setLineGraphColour)
        context.strokePath()
      }

      if source.enableDataPointLabel == true {
        textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: destination.x, y: destination.y - 15, width: 40, height: 20))
      }
    }
  }
  
  
}
