//
//  BarChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 08/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class BarChartView: BarChartRenderer {
  
  
  /// Legend visibility (Default = True)
  open var legendVisibility = true
  
  /// Legend Position (Default = bottom)
  open var legendPosition: legendPlacing = .bottom
  
  
  /// Custom legend x (When you select .custom on legend position then you can use this to set your own x values)
  open var customXlegend: Double = 0.0
  
  /// Custom legend y (When you select .custom on legend position then you can use this to set your own y values)
  open var customYlegend: Double = 0.0
  
  /// Enables the axis label customisation, if it is false then the max value of the data set will be taken and multiplied by 20% (Default = false)
  open var enableAxisCustomisation:Bool = false
  
  /// Enables the xAxis label customisation (Default = false)
  open var enableAxisLabelCustomisation: Bool = false
  
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
  
  /// The orientation of the graph
  open var barOrientation: barOrientation = .vertical
  
  /// Enable animation or not (Default = false)
  open var enableAnimation: Bool = false
  
  /// Enable highlighting (Default = true)
  open var enableHighlight: Bool = false
  
  public var data = BarChartDataSet()
  
  private var touchPosition = CGPoint(x: 0, y: 0)
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override open func layoutSubviews() {
    let scale = 70.0/31.0
    
    if enableAnimation == true {
      setNeedsDisplay()
      if UIDevice.current.orientation.isLandscape {
        renderAnimatedBar(as: .landscape, withConfiguration: scale)
      } else {
        renderAnimatedBar(as: .portrait, withConfiguration: 1.0)
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
    
    changeOffset(position: legendPosition)
    
    let scale = 70.0/31.0
    
    if UIDevice.current.orientation.isLandscape {
      renderGraphBase(as: .landscape, on: context, withConfiguration: scale)
      if enableAnimation == false {
        renderBarGraph(on: context)
      }
      if enableHighlight == true {
        renderHighlight(on: context, withConfiguration: scale)
      }
    } else {
      renderGraphBase(as: .portrait, on: context, withConfiguration: 1.0)
      if enableAnimation == false {
        renderBarGraph(on: context)
      }
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
  func changeOffset(position: legendPlacing) {
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
  

  func renderAnimatedBar(as currentOrientation: orientation, withConfiguration landscapePadding: Double) {
    self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    let helper = HelperFunctions()
    let convertedData = helper.convertToDouble(from: data.array)
    
    var maxValue = 0.0
    var minValue = 0.0
    
    let actualMax = helper.findMaxValueFrom(convertedData)
    
    if enableAxisCustomisation == true {
      maxValue = yAxis.setYAxisMaximumValue
      minValue = yAxis.setYAxisMinimumValue
    } else {
      maxValue = actualMax
      minValue = 0
    }
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    let animator = AnimationRenderer()
    
    
    for (i, value) in convertedData.enumerated() {
      animator.calculate = GraphCalculation(array: value, arrayCount: value.count, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
      animator.barCustomisationSource = data.array[i]
      animator.offSet = offSet
      animator.drawAnimatedBar(on: layer, using: value, with: Double(i), and: Double(convertedData.count), for: barOrientation)
    }
  }
  
  func renderHighlight(on context: CGContext, withConfiguration landscapePadding: Double) {
    let array = helper.convertToDouble(from: data.array)
    let actualMax = helper.findMaxValueFrom(array)
    let paddedLeftOffset = offSetLeft * landscapePadding
    let paddedRightOffset = offSetRight * landscapePadding
    let offSet = offset.init(left: paddedLeftOffset, right: paddedRightOffset, top: offSetTop, bottom: offSetBottom)
    
    var maxValue = 0.0
    var minValue = 0.0
    
    if enableAxisCustomisation == true {
      maxValue = yAxis.setYAxisMaximumValue
      minValue = yAxis.setYAxisMinimumValue
    } else {
      maxValue = actualMax
      minValue = 0
    }
    if barOrientation == .horizontal {
      highlightHorizontalValues(in: context, using: array, and: touchPosition, with: maxValue, minValue, Double(array.count), offSet)
    } else {
      highlightValues(in: context, using: array, and: touchPosition, with: maxValue, minValue, Double(array.count), offSet)
    }
    
  }
  
  func renderBarGraph(on context: CGContext) {
    let array = helper.convertToDouble(from: data.array)
    for (increment, value) in array.enumerated() {
      customisationSource = data.array[increment]
      if barOrientation == .horizontal {
        addHorizontalBarGraph(to: context, from: value, with: Double(increment), and: Double(array.count))
      } else {
        addVerticalBarGraph(to: context, from: value, with: Double(increment), and: Double(array.count))
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
    
    var maxValue = 0.0
    var minValue = 0.0
    
    let actualMax = helper.findMaxValueFrom(convertedData)
    
    if enableAxisCustomisation == true {
      if barOrientation == .horizontal {
        maxValue = xAxis.setXAxisMaximumValue
        minValue = xAxis.setXAxisMinimumValue
      } else {
        maxValue = yAxis.setYAxisMaximumValue
        minValue = yAxis.setYAxisMinimumValue
      }
    } else {
      maxValue = actualMax
      minValue = 0
    }
    
    for value in convertedData {
      calculate = GraphCalculation(array: value, arrayCount: value.count, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
    }
    
    labelRenderer.calculate = GraphCalculation(array: [], arrayCount: arrayCount, maxValue: maxValue, minValue: minValue, frameWidth: frameWidth(), frameHeight: frameHeight(), offSet: offSet, yAxisGridlineCount: yAxis.setGridlineCount, xAxisGridlineCount: xAxis.setGridlineCount)
    
    
    axisBase(context: context, offSet: offSet)
    if barOrientation == .horizontal {
      context.protectGState {
        drawHorizontalXGridlines(on: context, using: xAxis.setGridlineCount)
        drawHorizontalYGridlines(on: context, using: arrayCount)
      }
      labelRenderer.drawHorizontalYAxisLabel(on: context, withCustomisation: enableAxisLabelCustomisation, using: arrayCount, and: yAxis.setYAxisLabel, with: yAxis.rightYAxisVisibility, yAxis.leftYAxisVisibility)
        labelRenderer.drawHorizontalXAxisLabel(on: context, using: xAxis.setGridlineCount, with: xAxis.bottomXAxisVisibility, xAxis.topXAxisVisibility)
    } else {
      context.protectGState {
        drawBarXAxisGridline(on: context, using: arrayCount)
        drawYAxisGridline(on: context, using: yAxis.setGridlineCount)
      }
      labelRenderer.drawYAxisLabel(on: context, using: yAxis.setGridlineCount, withAxisInverse: yAxis.enableYAxisInverse, and: yAxis.rightYAxisVisibility, yAxis.leftYAxisVisibility)
        labelRenderer.drawbarXAxisLabel(on: context, withCustomisation: enableAxisLabelCustomisation, using: arrayCount, and: xAxis.setXAxisLabel, with: xAxis.bottomXAxisVisibility, xAxis.topXAxisVisibility)
    }
    
    if legendVisibility == true {
      legend.addLegend(to: context, using: data.array, and: legendPosition, customXlegend, customYlegend)
    }
  }
  
}
