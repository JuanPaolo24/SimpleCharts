//
//  CustomTypes.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 24/03/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation

public struct offset {
  var left: Double
  var right: Double
  var top: Double
  var bottom: Double
  
}

public enum position {
  case start, end
  
}

public enum legendPlacing {
  case left, right, bottom, top, custom
}

public enum pielegendPlacing {
  case left, right, bottom, top, topleft, topright, bottomleft, bottomright, custom
}

public enum orientation {
  case landscape, portrait
}

public enum filltype {
  case gradientFill, normalFill
  
  
}
