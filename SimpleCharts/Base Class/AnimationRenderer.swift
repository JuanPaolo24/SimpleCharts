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
  
  
  func drawAnimatedLineGraph(array: [[Double]], maxValue: Double, minValue: Double, offSet: offset, height: Double, width: Double, mainLayer: CALayer) {
    
    var calc = LineGraphCalculation(array: array[0], arrayCount: 0, maxValue: maxValue, minValue: minValue, frameWidth: width, frameHeight: height, offSet: offSet, yAxisGridlineCount: 0, xAxisGridlineCount: 0)
    
    let connection = CGMutablePath()
    
    let startingYValue = calc.ylineGraphStartPoint()
    let startingXValue = calc.xlineGraphPoint(i: 0)
    
    connection.move(to: CGPoint(x: startingXValue, y: startingYValue))
    
    
    for i in 0...array.count - 1  {
      for (j, value) in array[i].enumerated() {
        calc = LineGraphCalculation(array: array[i], arrayCount: 0, maxValue: maxValue, minValue: minValue, frameWidth: width, frameHeight: height, offSet: offSet, yAxisGridlineCount: 0, xAxisGridlineCount: 0)
        let xValue = calc.xlineGraphPoint(i: j)
        let yValue = calc.ylineGraphPoint(value: value)
        
        connection.addLine(to: CGPoint(x: xValue, y: yValue))
      }
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = connection
      shapeLayer.strokeColor = UIColor.blue.cgColor
      shapeLayer.fillColor = nil
      mainLayer.addSublayer(shapeLayer)
      
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.fromValue = 0
      animation.toValue = 1
      animation.duration = 2
      shapeLayer.add(animation, forKey: "line")
    }
  }
  
  
  
  func drawAnimatedBar(array: [[Double]], maxValue: Double, minValue: Double, arrayCount: Double, offSet: offset, mainLayer: CALayer) {
    
    var calc = BarGraphCalculation(frameHeight: Double(frame.size.height), frameWidth: Double(frame.size.width), maxValue: maxValue, minValue: minValue, arrayCount: Double(array.count), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
    
    var initialBound = CGRect()
    var finalBound = CGRect()
    var increaseBar = CABasicAnimation()
    
    for i in 0...array.count - 1 {
      for (j, value) in array[i].enumerated() {
        calc = BarGraphCalculation(frameHeight: Double(mainLayer.frame.height), frameWidth: Double(mainLayer.frame.width), maxValue: maxValue, minValue: minValue, arrayCount: Double(array[i].count), yAxisGridlineCount: 0, xAxisGridlineCount: 0, offSet: offSet)
        
        let width = calc.verticalWidth(count: arrayCount)
        let xValue = calc.xVerticalValue(i: j, dataSetCount: Double(i), count: arrayCount)
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
        barLayer.backgroundColor = UIColor(red:0.83, green:0.59, blue:0.67, alpha:1.0).cgColor
        barLayer.add(increaseBar, forKey: nil)
        mainLayer.addSublayer(barLayer)
        
      }
    }
    
    
    
    
    
  }
  
  
  
}
