//
//  SimpleChartsTests.swift
//  SimpleChartsTests
//
//  Created by Juan Paolo  Del Rosario on 28/02/2019.
//  Copyright © 2019 Juan Paolo Del Rosario. All rights reserved.
//

import XCTest
@testable import SimpleCharts

class SimpleChartsTests: XCTestCase {
  
  var chartRenderer: ChartRenderer!
  var array: [Double]!
  var max: Double!
  var calcPortrait: GraphCalculation!
  var calcLandscape: GraphCalculation!
  let helper = HelperFunctions()
  
  override func setUp() {

  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
  }
  
  
  func testfindArrayMaxValueFunction() {
    let sampleData:[[Double]] = [[100.0,200.0,150.0,60.0],[30.0,230.0,400.0]]
    let testFunction = helper.findMaxValueFrom(sampleData)
    
    XCTAssertEqual(testFunction, 480.0)
  }
  
  func testfindArrayCountFunction() {
    let sampleData:[[Double]] = [[100.0,200.0,150.0,60.0],[30.0,230.0,400.0],[100.0,200.0,150.0,60.0,30.0,230.0,400.0]]
    let testFunction = helper.findArrayCountFrom(array: sampleData)
    
    XCTAssertEqual(testFunction, 7)
  }
  
  
  func testBinarySearchFunction() {
    let helper = HelperFunctions()
    let sampleArray = [CGPoint(x: 30, y: 50), CGPoint(x: 50, y: 100), CGPoint(x: 100, y: 500), CGPoint(x: 150, y: 400)]
    let startBinary = helper.returnClosestPoint(from: sampleArray, using: CGPoint(x: 35, y: 530))
    let midBinary = helper.returnClosestPoint(from: sampleArray, using: CGPoint(x: 70, y: 350))
    let endBinary = helper.returnClosestPoint(from: sampleArray, using: CGPoint(x: 140, y: 200))
    
    XCTAssertEqual(startBinary, CGPoint(x: 30, y: 50))
    XCTAssertEqual(midBinary, CGPoint(x: 50, y: 100))
    XCTAssertEqual(endBinary, CGPoint(x: 150, y: 400))
    
  }


  
  func testCombinedCGPointArrayFunction() {
    let helper = HelperFunctions()
    let array = [CGPoint(x: 60, y: 50), CGPoint(x: 50, y: 100), CGPoint(x: 100, y: 500), CGPoint(x: 150, y: 400)]
    let result = helper.combineCGPoint(Array: array)
    
    XCTAssertEqual(result, [CGPoint(x: 50, y: 100), CGPoint(x: 60, y: 50), CGPoint(x: 100, y: 500), CGPoint(x: 150, y: 400)])
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
