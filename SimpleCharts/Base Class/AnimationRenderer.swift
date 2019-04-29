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
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  func drawAnimatedLineGraph(array: [Double], maxValue: Double, minValue: Double, offSet: offset, height: Double, width: Double, mainLayer: CALayer, source: LineChartData) {
    
    var calc = LineGraphCalculation(array: array, arrayCount: 0, maxValue: maxValue, minValue: minValue, frameWidth: width, frameHeight: height, offSet: offSet, yAxisGridlineCount: 0, xAxisGridlineCount: 0)
    
    let connection = CGMutablePath()
    
    let startingYValue = calc.ylineGraphStartPoint()
    let startingXValue = calc.xlineGraphPoint(i: 0)
    
    connection.move(to: CGPoint(x: startingXValue, y: startingYValue))
    
    
    for (j, value) in array.enumerated() {
        let xValue = calc.xlineGraphPoint(i: j)
        let yValue = calc.ylineGraphPoint(value: value)
        
        connection.addLine(to: CGPoint(x: xValue, y: yValue))
        
      }
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = connection
      shapeLayer.strokeColor = source.setLineGraphColour
      shapeLayer.fillColor = nil
      mainLayer.addSublayer(shapeLayer)
      
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.fromValue = 0
      animation.toValue = 1
      animation.duration = 4
      shapeLayer.add(animation, forKey: "line")
    }
  
  
  
  func drawAnimatedBar(array: [Double], maxValue: Double, minValue: Double, arrayCount: Double, dataSetCount: Int, offSet: offset, mainLayer: CALayer, source: BarChartData) {
    
    var calc = BarGraphCalculation(frameHeight: Double(frame.size.height), frameWidth: Double(frame.size.width), maxValue: maxValue, minValue: minValue, arrayCount: Double(array.count), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
    
    var initialBound = CGRect()
    var finalBound = CGRect()
    var increaseBar = CABasicAnimation()
    
    //for i in 0...array.count - 1 {
      for (j, value) in array.enumerated() {
        calc = BarGraphCalculation(frameHeight: Double(mainLayer.frame.height), frameWidth: Double(mainLayer.frame.width), maxValue: maxValue, minValue: minValue, arrayCount: Double(array.count), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
        
        let width = calc.verticalWidth(count: arrayCount)
        let xValue = calc.xVerticalValue(i: j, dataSetCount: Double(dataSetCount), count: arrayCount)
        let yValue = calc.yVerticalValue(value: value)
        let height = calc.verticalHeight(value: value)
        
        initialBound = CGRect(x: xValue, y: Double(mainLayer.frame.height) - offSet.bottom, width: width, height: 0)
        finalBound = CGRect(x: xValue, y: yValue, width: width, height: height)
        
        increaseBar = CABasicAnimation(keyPath: "bounds")
        increaseBar.fromValue = initialBound
        increaseBar.toValue = finalBound
        increaseBar.duration = 2.0
        
        let barLayer = CALayer()
        // my code line
        barLayer.anchorPoint = CGPoint(x: 1, y: 1)
        barLayer.frame = finalBound
        barLayer.backgroundColor = source.setBarGraphFillColour
        barLayer.add(increaseBar, forKey: nil)
        mainLayer.addSublayer(barLayer)
        
      }
    //}
  
  }
  
  
  func drawAnimatedPie(radiusPercentage: CGFloat, segments: PieChartDataSet, centerX: CGFloat, centerY: CGFloat, mainLayer: CALayer) {
    let radius = min(frame.size.width, frame.size.height) * radiusPercentage
    //let viewCenter = CGPoint(x: bounds.size.width * 0.4, y: bounds.size.height * 0.5)
    let viewCenter = CGPoint(x: centerX, y: centerY)
    let valueCount = segments.array.reduce(0, {$0 + $1.value})
    
    let textRenderer = TextRenderer(font: UIFont.systemFont(ofSize: 12.0, weight: .bold), foreGroundColor: UIColor(red:0.65, green:0.65, blue:0.65, alpha:1.0))
    
    var startAngle = -CGFloat.pi * 0.5
    
    for segment in segments.array {
      
      let path = CGMutablePath()
      
      let endAngle = startAngle + 2 * .pi * (segment.value / valueCount)
      
      let halfAngle = startAngle + (endAngle - startAngle) * 0.5
      let labelPosition = CGFloat(0.8)
      let labelXPosition = viewCenter.x + (radius * labelPosition) * cos(halfAngle)
      let labelYPosition = viewCenter.y + (radius * labelPosition) * sin(halfAngle)
      
      
      path.move(to: viewCenter)
      path.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
      
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = path
      shapeLayer.fillColor = segment.color.cgColor
      
      let maskPath = CGMutablePath()
      maskPath.move(to: viewCenter)
      maskPath.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
      
      let shapeLayerMask = CAShapeLayer()
      shapeLayerMask.path = maskPath
      shapeLayerMask.fillColor = segment.color.cgColor
      shapeLayerMask.lineWidth = radius
      shapeLayerMask.strokeStart = 0
      shapeLayerMask.strokeEnd = 1
      
      shapeLayer.mask = shapeLayerMask
      
      let animation = CABasicAnimation(keyPath: "bounds")
      animation.fromValue = shapeLayerMask.strokeStart
      animation.toValue = shapeLayerMask.strokeEnd
      animation.duration = 2
      animation.timingFunction = CAMediaTimingFunction(name: .linear)
      animation.isRemovedOnCompletion = false
      animation.autoreverses = false
      shapeLayer.add(animation, forKey: nil)
      mainLayer.addSublayer(shapeLayer)
      
      
      
      textRenderer.renderText(text: "\(segment.value)", textFrame: CGRect(x: labelXPosition, y: labelYPosition , width: 40, height: 20))
      
      startAngle = endAngle
    
    
  }
  
  }
  
}
