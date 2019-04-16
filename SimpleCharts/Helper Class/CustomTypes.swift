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

@objc public enum legendPlacing: Int, RawRepresentable {
  case left, right, bottom, top, custom
  
  public typealias RawValue = String
  
  public var rawValue: RawValue {
    switch self {
    case.left:
      return "left"
    case.right:
      return "right"
    case.bottom:
      return "bottom"
    case.top:
      return "top"
    case.custom:
      return "custom"
    }
  }
  
  public init?(rawValue: RawValue) {
    switch rawValue {
    case "left":
      self = .left
    case "right":
      self = .right
    case "bottom":
      self = .bottom
    case "top":
      self = .top
    case "custom":
      self = .custom
    default:
      self = .bottom
    }
  }
}

public enum pielegendPlacing {
  case left, right, bottom, top, topleft, topright, bottomleft, bottomright, custom
}

public enum orientation {
  case landscape, portrait
}

@objc public enum filltype: Int, RawRepresentable {
  case gradientFill, normalFill
  
  public typealias RawValue = String
  
  public var rawValue: RawValue {
    switch self {
    case.gradientFill:
      return "gradientFill"
    case.normalFill:
      return "normalFill"
    }
  }
  
  public init?(rawValue: RawValue) {
    switch rawValue {
    case "gradientFill":
      self = .gradientFill
    case "normalFill":
      self = .normalFill
    default:
      self = .normalFill
    }
  }
  
}
