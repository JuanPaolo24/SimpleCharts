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
      let yValue = calculate.ylineGraphPoint(value: value)
      
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
          let colorComponents = helper.createColourStructure(from: sourceData.gradientFillColours)
          
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
          
          let colorComponents = helper.createColourStructure(from: sourceData.gradientFillColours)
          
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
  
  
  func addCircles(to context: CGContext, from array: [Double]) {
    for (increment, value) in array.enumerated() {
      
      let xValue = calculate.xlineGraphPoint(for: .singleChart, from: increment)
      let yValue = calculate.ylineGraphPoint(value: value)
      
      if sourceData.enableCirclePointVisibility == true {
        context.addArc(center: CGPoint(x: xValue, y: yValue), radius: sourceData.setCirclePointRadius, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
        context.setFillColor(sourceData.setLineGraphColour)
        context.fillPath()
      }
    }
  }
  
  
  /// Base function for drawing single line graphs. Requires context, the array to be plotted and the max value of the whole data set
  func addLine(to context: CGContext, from array: [Double], for type: chartType) {
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: sourceData.setTextLabelFont), foreGroundColor: sourceData.setTextLabelColour)
    
    let startingYValue = calculate.ylineGraphStartPoint()
    let startingXValue = calculate.xlineGraphPoint(for: type, from: 0)
    
    let linePath = CGMutablePath()
    linePath.move(to: CGPoint(x: startingXValue, y: startingYValue))
    
    for (increment, value) in array.enumerated() {
      
      let xValue = calculate.xlineGraphPoint(for: type, from: increment)
      let yValue = calculate.ylineGraphPoint(value: value)
      
      if sourceData.enableLineVisibility == true {
        context.protectGState {
          linePath.addLine(to: CGPoint(x: xValue, y: yValue))
          context.addPath(linePath)
          context.setStrokeColor(sourceData.setLineGraphColour)
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
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: sourceData.setTextLabelFont), foreGroundColor: sourceData.setTextLabelColour)
    
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
        context.setStrokeColor(sourceData.setLineGraphColour)
        context.strokePath()
      }

      if sourceData.enableDataPointLabel == true {
        textRenderer.renderText(text: "\(value)", textFrame: CGRect(x: destination.x, y: destination.y - 15, width: 40, height: 20))
      }
    }
  }
  
  
}
