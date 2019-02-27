//
//  PieChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 26/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

open class PieChartView: ArcRenderer {
  
  public var data = PieChartDataSet(dataset: [PieChartData(color: UIColor.white, value: 0, name: "")])
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard let context = UIGraphicsGetCurrentContext() else {
      print("could not get context")
      return
    }
    
    if UIDevice.current.orientation.isLandscape {
      drawPieArc(context: context, radiusPercentage: 0.4, segments: data)
    } else {
      drawPieArc(context: context, radiusPercentage: 0.4, segments: data)
    }
  
    
    let legend = LegendRenderer(frame: self.frame)
    
    legend.renderPieChartLegend(context: context, arrays: data.array)
  }
  
}
