//
//  LineChartViewPort.swift
//  SimpleCharts
//
//  Created by Juan Paolo  Del Rosario on 17/04/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import Foundation


open class LineChartViewPort: ChartRenderer {
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor(red:0.24, green:0.24, blue:0.24, alpha:0.5)
  }
  
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    guard let context = UIGraphicsGetCurrentContext() else {
      print("could not get context")
      return
      
    }
    
    let offSet = offset.init(left: 31, right: 31, top: 20, bottom: 62)
    xAxisBase(context: context, offSet: offSet)

    
  }
   var lastLocation = CGPoint(x: 0, y: 0)
  var lastScale:CGFloat = 0.0
  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let position = touch.location(in: self)
      let touchCount = touch.tapCount
      setNeedsDisplay()
      
    }

    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureAction))
    self.addGestureRecognizer(pinchGesture)
  }
  
  @objc func panGestureAction(_ recognizer:UIPanGestureRecognizer) {
    
  }
  
  @objc func pinchGestureAction(_ recognizer:UIPinchGestureRecognizer) {
    let currentScale = CGFloat((recognizer.view?.layer.value(forKeyPath: "transform.scale") as? NSNumber)?.floatValue ?? 0.0)
    
    // Constants to adjust the max/min values of zoom
    let kMaxScale: CGFloat = 1.0
    let kMinScale: CGFloat = 0.5
    
    var newScale: CGFloat = 1 - (lastScale - (recognizer.scale ))
    newScale = min(newScale, kMaxScale / currentScale)
    newScale = max(newScale, kMinScale / currentScale)
    let transform: CGAffineTransform = (recognizer.view?.transform.scaledBy(x: newScale, y: newScale))!
    
   
    lastScale = recognizer.scale
    
     self.transform = transform
  }

  
}
