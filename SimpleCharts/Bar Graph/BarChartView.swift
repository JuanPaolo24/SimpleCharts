//
//  BarChartView.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 08/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class BarChartView: ChartRenderer {
  
  public var data: [Double]
  
  override public init(frame: CGRect) {
    self.data = [Double]()
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
    
    
    
  }
  
  
}
