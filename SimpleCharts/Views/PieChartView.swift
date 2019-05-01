//
//  PieChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 26/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

open class PieChartView: ArcRenderer {
  
  /// Legend visibility (Default = True)
  open var legendVisibility = true
  
  /// Returns true if legend is visible
  open var isLegendVisible: Bool { get {return legendVisibility} }
  
  /// Legend Position (Default = Top right)
  open var legendPosition: pielegendPlacing = .topright
  
  /// Custom legend x (When you select .custom on legend position then you can use this to set your own x values)
  open var customXlegend: Double = 0.0
  
  /// Custom legend y (When you select .custom on legend position then you can use this to set your own y values)
  open var customYlegend: Double = 0.0
  
  
  public var data = PieChartDataSet(dataset: [PieChartData(color: UIColor.white, value: 0, name: "")])
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override func layoutSubviews() {
    let scale = 70.0/31.0
    let animation = AnimationRenderer(frame: self.frame)
    let height = frame.size.height
    let width = frame.size.width
    print(height)
    
    if UIDevice.current.orientation.isLandscape {
      animation.drawAnimatedPie(radiusPercentage: 0.4, segments: data, centerX: width * 0.5, centerY: height * 0.5, mainLayer: layer)
    } else {
      animation.drawAnimatedPie(radiusPercentage: 0.4, segments: data, centerX: width * 0.5, centerY: height * 0.5, mainLayer: layer)
    }
  }
  
  
  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard let context = UIGraphicsGetCurrentContext() else {
      print("could not get context")
      return
    }
    
  
    if UIDevice.current.orientation.isLandscape {
      //renderPieChart(context: context, currentOrientation: orientation.landscape)
    } else {
      //renderPieChart(context: context, currentOrientation: orientation.portrait)
    }
  
    
    
  }
  
  
  func renderPieChart(context: CGContext, currentOrientation: orientation) {
    let height = frame.size.height
    let width = frame.size.width
    let legend = LegendRenderer(frame: self.frame)
    legend.legendPadding(currentOrientation: currentOrientation)
    
    if currentOrientation == orientation.portrait {
      if legendPosition == pielegendPlacing.right {
        drawPieArc(context: context, radiusPercentage: 0.4, segments: data, centerX: width * 0.4, centerY: height * 0.5)
      } else if legendPosition == pielegendPlacing.left {
        drawPieArc(context: context, radiusPercentage: 0.4, segments: data, centerX: width * 0.6, centerY: height * 0.5)
      } else {
        drawPieArc(context: context, radiusPercentage: 0.4, segments: data, centerX: width * 0.5, centerY: height * 0.5)
      }
    } else {
      drawPieArc(context: context, radiusPercentage: 0.4, segments: data, centerX: width * 0.5, centerY: height * 0.5)
    }
    
    
    legend.renderPieChartLegend(context: context, arrays: data.array, position: legendPosition, customX: customXlegend, customY: customYlegend)
  }
  
}
