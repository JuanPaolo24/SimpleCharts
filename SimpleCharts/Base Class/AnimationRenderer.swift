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
      shapeLayer.strokeColor = lineCustomisationSource.setLineGraphColour
      shapeLayer.fillColor = nil
      mainLayer.addSublayer(shapeLayer)
      
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.fromValue = 0
      animation.toValue = 1
      animation.duration = 4
      shapeLayer.add(animation, forKey: "line")
    }
  
  
  
  func drawAnimatedBar(on mainLayer: CALayer, using array: [Double], with dataSetIncrement: Double, and dataSetCount: Double, for orientation: barOrientation) {
    
    var initialBound = CGRect()
    var finalBound = CGRect()
    var increaseBar = CABasicAnimation()
    
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
      
      increaseBar = CABasicAnimation(keyPath: "bounds")
      increaseBar.fromValue = initialBound
      increaseBar.toValue = finalBound
      increaseBar.duration = 2.0
      let barLayer = CALayer()
      barLayer.anchorPoint = anchor
      barLayer.frame = finalBound
      barLayer.backgroundColor = barCustomisationSource.setBarGraphFillColour
      barLayer.add(increaseBar, forKey: nil)
      mainLayer.addSublayer(barLayer)
      
    }
  }
  
  

//  func drawAnimatedPie(radiusPercentage: CGFloat, segments: PieChartDataSet, centerX: CGFloat, centerY: CGFloat, mainLayer: CALayer) {
//    let radius = min(frame.size.width, frame.size.height) * radiusPercentage
//    //let viewCenter = CGPoint(x: bounds.size.width * 0.4, y: bounds.size.height * 0.5)
//    let viewCenter = CGPoint(x: centerX, y: centerY)
//    let valueCount = segments.array.reduce(0, {$0 + $1.value})
//
//    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: 12.0, weight: .bold), foreGroundColor: UIColor(red:0.65, green:0.65, blue:0.65, alpha:1.0))
//
//    var startAngle = -CGFloat.pi * 0.5
//
//    for segment in segments.array {
//
//      let path = CGMutablePath()
//
//      let endAngle = startAngle + 2 * .pi * (segment.value / valueCount)
//
//      let halfAngle = startAngle + (endAngle - startAngle) * 0.5
//      let labelPosition = CGFloat(0.8)
//      let labelXPosition = viewCenter.x + (radius * labelPosition) * cos(halfAngle)
//      let labelYPosition = viewCenter.y + (radius * labelPosition) * sin(halfAngle)
//
//
//      path.move(to: viewCenter)
//      path.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//
//      let shapeLayer = CAShapeLayer()
//      shapeLayer.path = path
//      shapeLayer.fillColor = segment.color.cgColor
//
//      let maskPath = CGMutablePath()
//      maskPath.move(to: viewCenter)
//      maskPath.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//
//      let shapeLayerMask = CAShapeLayer()
//      shapeLayerMask.path = maskPath
//      shapeLayerMask.fillColor = segment.color.cgColor
//      shapeLayerMask.lineWidth = radius
//      shapeLayerMask.strokeStart = 0
//      shapeLayerMask.strokeEnd = 1
//
//      shapeLayer.mask = shapeLayerMask
//
//      let animation = CABasicAnimation(keyPath: "bounds")
//      animation.fromValue = shapeLayerMask.strokeStart
//      animation.toValue = shapeLayerMask.strokeEnd
//      animation.duration = 2
//      animation.timingFunction = CAMediaTimingFunction(name: .linear)
//      animation.isRemovedOnCompletion = false
//      animation.autoreverses = false
//      shapeLayer.add(animation, forKey: nil)
//      mainLayer.addSublayer(shapeLayer)
//
//
//
//      textRenderer.renderText(text: "\(segment.value)", textFrame: CGRect(x: labelXPosition, y: labelYPosition , width: 40, height: 20))
//
//      startAngle = endAngle
//
//
//  }
//
//  }
  
}
