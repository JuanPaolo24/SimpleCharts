//
//  AnimationRenderer.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 27/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

//This class will handle all the animation rendering needed

open class AnimationRenderer: UIView {
  
  var calculate = GraphCalculation()
  var offSet = offset(left: 0, right: 0, top: 0, bottom: 0)
  var lineCustomisationSource = LineChartData()
  var barCustomisationSource = BarChartData()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func drawAnimatedLineGraph(on mainLayer: CALayer, using array: [Double]) {
    let animatedPath = CGMutablePath()
    let startingYValue = calculate.ylineGraphStartPoint()
    let startingXValue = calculate.xlineGraphPoint(for: .singleChart, from: 0)
    animatedPath.move(to: CGPoint(x: startingXValue, y: startingYValue))
    
    for (increment, value) in array.enumerated() {
      let xValue = calculate.xlineGraphPoint(for: .singleChart, from: increment)
      let yValue = calculate.ylineGraphPoint(from: value)
      animatedPath.addLine(to: CGPoint(x: xValue, y: yValue))
    }
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = animatedPath
    shapeLayer.strokeColor = lineCustomisationSource.setLineGraphColor.cgColor
    shapeLayer.fillColor = nil
    shapeLayer.lineWidth = lineCustomisationSource.setLineWidth
    
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = lineCustomisationSource.setAnimationDuration
    shapeLayer.add(animation, forKey: "line")
    mainLayer.addSublayer(shapeLayer)
  }
  
  
  
  //Draw a special case of a circle for the combine chart to ensure that the circle goes on top of the bar
  func drawAnimatedCombineLine(on mainLayer: CALayer, using array: [Double]) {
    let animatedPath = CGMutablePath()
    let startingYValue = calculate.ylineGraphStartPoint()
    let startingXValue = calculate.xlineGraphPoint(for: .combineChart, from: 0)
    animatedPath.move(to: CGPoint(x: startingXValue, y: startingYValue))
    
    for (increment, value) in array.enumerated() {
      let xValue = calculate.xlineGraphPoint(for: .combineChart, from: increment)
      let yValue = calculate.ylineGraphPoint(from: value)
      animatedPath.addLine(to: CGPoint(x: xValue, y: yValue))
      let circleLayer = CAShapeLayer()
      circleLayer.path = UIBezierPath(arcCenter: CGPoint(x: xValue, y: yValue), radius: lineCustomisationSource.setCirclePointRadius, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true).cgPath
      circleLayer.fillColor = lineCustomisationSource.setLineGraphColor.cgColor
      mainLayer.addSublayer(circleLayer)
    }
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = animatedPath
    shapeLayer.strokeColor = lineCustomisationSource.setLineGraphColor.cgColor
    shapeLayer.fillColor = nil
    shapeLayer.lineWidth = lineCustomisationSource.setLineWidth
    mainLayer.addSublayer(shapeLayer)
    
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = lineCustomisationSource.setAnimationDuration
    shapeLayer.add(animation, forKey: "line")
    
  }
  
  
  
  func drawAnimatedBar(on mainLayer: CALayer, using array: [Double], with dataSetIncrement: Double, and dataSetCount: Double, for orientation: barOrientation) {
    
    var initialBound = CGRect()
    var finalBound = CGRect()
    
    
    for (increment, value) in array.enumerated() {
      var width = 0.0
      var height = 0.0
      var xValue = 0.0
      var yValue = 0.0
      var anchor = CGPoint()
      if orientation == .horizontal {
        width = calculate.horizontalWidth(using: value)
        xValue = calculate.xHorizontalValue()
        yValue = calculate.yHorizontalValue(using: increment, with: dataSetIncrement, and: dataSetCount)
        height = calculate.horizontalHeight(using: dataSetCount)
        initialBound = CGRect(x: xValue, y: yValue, width: 0, height: height)
        finalBound = CGRect(x: xValue, y: yValue, width: width, height: height)
        anchor = CGPoint(x: 0, y: 0)
      } else {
        width = calculate.verticalWidth(using: dataSetCount)
        xValue = calculate.xVerticalValue(using: increment, with: dataSetIncrement, and: dataSetCount)
        yValue = calculate.yVerticalValue(using: value)
        height = calculate.verticalHeight(using: value)
        initialBound = CGRect(x: xValue, y: Double(mainLayer.frame.height) - offSet.bottom, width: width, height: 0)
        finalBound = CGRect(x: xValue, y: yValue, width: width, height: height)
        anchor = CGPoint(x: 1, y: 1)
      }
      
      var animation = CABasicAnimation()
      animation = CABasicAnimation(keyPath: "bounds")
      animation.fromValue = initialBound
      animation.toValue = finalBound
      animation.duration = barCustomisationSource.setAnimationDuration
      let barLayer = CALayer()
      barLayer.anchorPoint = anchor
      barLayer.frame = finalBound
      barLayer.backgroundColor = barCustomisationSource.setBarGraphFillColor.cgColor
      barLayer.add(animation, forKey: nil)
      mainLayer.addSublayer(barLayer)
      
    }
  }
  
}
