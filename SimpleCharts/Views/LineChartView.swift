//
//  ChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 07/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LineChartView: LineChartRenderer {
  

  /// Legend visibility (Default = True)
  open var legendVisibility = true

  /// Legend Position (Default = bottom)
  open var legendPosition: legendPlacing = .bottom
  
  
  /// Custom legend x (When you select .custom on legend position then you can use this to set your own x values)
  open var customXlegend: Double = 0.0
  
  /// Custom legend y (When you select .custom on legend position then you can use this to set your own y values)
  open var customYlegend: Double = 0.0
  
  /// Enables the axis label customisation, if it is false then the max value of the data set will be taken and multiplied by 20% (Default = false)
  open var enableAxisCustomisation = false

  /// Graph off set on the left (Default = 31)
  open var offSetLeft:Double = 31.0
  
  /// Graph off set on the right (Default = 31)
  open var offSetRight:Double = 31.0
  
  /// Graph off set on the bottom (Default = 62)
  open var offSetBottom:Double = 62.0
  
  /// Graph off set on the top (Default = 20)
  open var offSetTop:Double = 20.0
  
  
  /// An instance of the xAxis to provide customisation through this
  open var xAxis:xAxisConfiguration = xAxisConfiguration()
  
  /// An instance of the yAxis to provide customisation through this
  open var yAxis:yAxisConfiguration = yAxisConfiguration()
  
  /// Line type
  open var lineType: lineType = .normal
  
  /// Activate animation
  open var enableAnimation = true
  
  /// Enable highlighting (Default = true)
  open var enableHighlight: Bool = true
  
  open var touchPosition = CGPoint(x: 0, y: 0)
  
  public var data = LineChartDataSet()
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override func layoutSubviews() {
    let scale = 70.0/31.0
    
    if enableAnimation == true {
      setNeedsDisplay()
      if UIDevice.current.orientation.isLandscape {
        renderAnimatedLine(withConfiguration: scale)
      } else {
        renderAnimatedLine(withConfiguration: 1.0)
      }
    } else {
      setNeedsDisplay()
    }
    
  }
  

  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    guard let context = UIGraphicsGetCurrentContext() else {
      print("could not get context")
      return
    }
    
    changeDefaultOffset(position: legendPosition)
    
    let scale = 70.0/31.0
    
      if UIDevice.current.orientation.isLandscape {
        renderGraphBase(as: .landscape, on: context, withConfiguration: scale)
        renderLineGraph(on: context, withConfiguration: scale)
        if enableHighlight == true {
          renderHighlight(on: context, withConfiguration: scale)
        }
      } else {
        renderGraphBase(as: .portrait, on: context, withConfiguration: 1.0)
        renderLineGraph(on: context, withConfiguration: 1.0)
        if enableHighlight == true {
          renderHighlight(on: context, withConfiguration: 1.0)
        }
      }
    
  }
  
  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let position = touch.location(in: self)
      touchPosition = position
      setNeedsDisplay()
    }
  }
  
  
  override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let position = touch.location(in: self)
      touchPosition = position
      setNeedsDisplay()
    }
  }
  
  
  // Changes offset configuration based on the position of the legend
  // This is for the default configuration
  func changeDefaultOffset(position: legendPlacing) {
    switch position {
    case .bottom:
      offSetLeft = 31.0
      offSetRight = 31.0
      offSetBottom = 62.0
      offSetTop = 20.0
    case .top:
      offSetLeft = 31.0
      offSetRight = 31.0
      offSetBottom = 31.0
      offSetTop = 50.0
    case .right:
      offSetLeft = 31.0
      offSetRight = 70.0
      offSetBottom = 31.0
      offSetTop = 20.0
    case .left:
      offSetLeft = 70.0
      offSetRight = 31.0
      offSetBottom = 31.0
      offSetTop = 20.0
    case .custom:
      offSetLeft = 31.0
      offSetRight = 31.0
      offSetBottom = 62.0
      offSetTop = 20.0
    }
    
  }
  
  
  /// Renders a line graph
  func renderLineGraph(on context: CGContext, withConfiguration landscapePadding: Double) {
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let convertedData = helper.convertToDouble(from: data.array)
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    let actualMax = helper.findMaxValueFrom(convertedData)
    
    var maxValue = 0.0
    var minValue = 0.0
    if enableAxisCustomisation == true {
      maxValue = yAxis.setYAxisMaximumValue
      minValue = yAxis.setYAxisMinimumValue
    } else {
      maxValue = actualMax
      minValue = 0
    }
    
    for (increment, value) in convertedData.enumerated() {
      calculate = GraphCalculation(array: value, arrayCount: arrayCount, maxValue: maxValue, minValue: minValue, frameWidth: Double(frame.size.width), frameHeight: Double(frame.size.height), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
      sourceData = data.array[increment]
      addCircles(to: context, from: value, for: .singleChart)
      if enableAnimation == false {
        if lineType == .bezier {
          addBezierLine(to: context, from: value, for: .singleChart)
          addBezierGradient(to: context, using: value, offSet: offSet)
        } else {
          addLine(to: context, from: value, for: .singleChart)
          addGradient(to: context, using: value, offSet: offSet)
        }
      }
      
    }
  }

  func renderGraphBase(as currentOrientation: orientation, on context: CGContext, withConfiguration landscapePadding: Double) {
    let helper = HelperFunctions()
    let convertedData = helper.convertToDouble(from: data.array)
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    let labelRenderer = AxisLabelRenderer(frame: self.frame)
    let legend = LegendRenderer(frame: self.frame)
    legend.legendPadding(currentOrientation: currentOrientation)
    
    let actualMax = helper.findMaxValueFrom(convertedData)
    
    var maxValue = 0.0
    var minValue = 0.0
    if enableAxisCustomisation == true {
      maxValue = yAxis.setYAxisMaximumValue
      minValue = yAxis.setYAxisMinimumValue
    } else {
      maxValue = actualMax
      minValue = 0
    }
    
    for value in convertedData {
      calculate = GraphCalculation(array: value, arrayCount: arrayCount, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
    }
    
    labelRenderer.calculate = GraphCalculation(array: [], arrayCount: arrayCount, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
    
    axisBase(context: context, offSet: offSet)
    drawXAxisGridline(on: context, using: xAxis.setGridlineCount)
    drawYAxisGridline(on: context, using: yAxis.setGridlineCount)
    labelRenderer.drawYAxisLabel(on: context, using: yAxis.setGridlineCount, withAxisInverse: yAxis.enableYAxisInverse, and: yAxis.rightYAxisVisibility, yAxis.leftYAxisVisibility)
    labelRenderer.drawXAxisLabel(on: context, using: xAxis.setGridlineCount, with: xAxis.bottomXAxisVisibility, xAxis.topXAxisVisibility)
    if legendVisibility == true {
      legend.addLegend(to: context, using: data.array, and: legendPosition, customXlegend, customYlegend)
    }
  }
  
  
  func renderHighlight(on context: CGContext, withConfiguration landscapePadding: Double) {
    let convertedData = helper.convertToDouble(from: data.array)
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    let actualMax = helper.findMaxValueFrom(convertedData)
    
    var maxValue = 0.0
    var minValue = 0.0
    if enableAxisCustomisation == true {
      maxValue = yAxis.setYAxisMaximumValue
      minValue = yAxis.setYAxisMinimumValue
    } else {
      maxValue = actualMax
      minValue = 0
    }
    highlightValues(in: context, using: convertedData, and: touchPosition, with: maxValue, minValue, offSet)
  }


  func renderAnimatedLine(withConfiguration landscapePadding: Double) {
    self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    let animationHandler = AnimationRenderer(frame: self.frame)
    let helper = HelperFunctions()
    let convertedData = helper.convertToDouble(from: data.array)
    
    var maxValue = 0.0
    var minValue = 0.0
    let arrayCount = helper.findArrayCountFrom(array: convertedData)
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    
    let actualMax = helper.findMaxValueFrom(convertedData)
    
    if enableAxisCustomisation == true {
      maxValue = yAxis.setYAxisMaximumValue
      minValue = yAxis.setYAxisMinimumValue
    } else {
      maxValue = actualMax
      minValue = 0
    }
    for (i, value) in convertedData.enumerated() {
      animationHandler.calculate = GraphCalculation(array: value, arrayCount: arrayCount, maxValue: maxValue, minValue: minValue, frameWidth: Double(frame.size.width), frameHeight: Double(frame.size.height), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
      animationHandler.lineCustomisationSource = data.array[i]
      animationHandler.drawAnimatedLineGraph(on: layer, using: value)

    }
  }
}



