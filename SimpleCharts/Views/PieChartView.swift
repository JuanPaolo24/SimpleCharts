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
  
  /// Legend Position (Default = Top right)
  open var legendPosition: pielegendPlacing = .topright
  
  /// Custom legend x (When you select .custom on legend position then you can use this to set your own x values)
  open var customXlegend: Double = 0.0
  
  /// Custom legend y (When you select .custom on legend position then you can use this to set your own y values)
  open var customYlegend: Double = 0.0
  
  /// Enter your PieChartDataSet here
  public var data = PieChartDataSet()
  
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override func layoutSubviews() {
    setNeedsDisplay()
  }
  
  
  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    guard let context = UIGraphicsGetCurrentContext() else {
      print("could not get context")
      return
    }
    if UIDevice.current.orientation.isLandscape {
      renderPieChart(as: .landscape, on: context)
    } else {
      renderPieChart(as: .portrait, on: context)
    }
  }
  
  func renderPieChart(as currentOrientation: orientation, on context: CGContext) {
    let height = frame.size.height
    let width = frame.size.width
    let renderer = LegendRenderer(frame: self.frame)
    renderer.setLegendPadding(as: currentOrientation)
    
    if currentOrientation == orientation.portrait {
      if legendPosition == pielegendPlacing.right {
        drawPieArc(on: context, using: data, with: width * 0.4, and: height * 0.5)
      } else if legendPosition == pielegendPlacing.left {
        drawPieArc(on: context, using: data, with: width * 0.6, and: height * 0.5)
      } else {
        drawPieArc(on: context, using: data, with: width * 0.5, and: height * 0.5)
      }
    } else {
      drawPieArc(on: context, using: data, with: width * 0.5, and: height * 0.5)
    }
    
    renderer.addLegend(to: context, using: data.array, and: legendPosition, customXlegend, customYlegend)
  }
  
}
