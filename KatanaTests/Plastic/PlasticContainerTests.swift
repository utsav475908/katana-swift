//
//  PlasticContainerTests.swift
//  Katana
//
//  Created by Mauro Bolis on 16/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import XCTest
@testable import Katana

private enum Keys: String, NodeDescriptionKeys {
  case One, OneA, OneB, OneAInner
  case Two
  case Four
}

class PlasticViewsContainerTests: XCTestCase {
  
  func testShouldCreateRootElement() {
    let hierarchy: [AnyNodeDescription] = []
    let rootFrame = CGRect(x: 0, y: 10, width: 20, height: 30)
    let plasticViewsContainer = ViewsContainer<Keys>(rootFrame: rootFrame, children: hierarchy, multiplier: 1)
    
    let rootPlaceholder = plasticViewsContainer.rootView
    XCTAssertEqual(rootPlaceholder.frame, rootFrame)
  }
  
  func testShouldCreateChildren() {
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps().key(Keys.One)) {
        [
          View(props: ViewProps().key(Keys.OneA)),
          View(props: ViewProps().key(Keys.OneB)),
        ]
      },
      
      View(props: ViewProps().key(Keys.Two)),
      View(props: ViewProps()),
      View(props: ViewProps().key(Keys.Four)),
      ]
    
    
    let plasticViewsContainer = ViewsContainer<Keys>(rootFrame: CGRect.zero, children: hierarchy, multiplier: 1)
    
    XCTAssertNotNil(plasticViewsContainer.rootView)
    XCTAssertNotNil(plasticViewsContainer[.One])
    XCTAssertNotNil(plasticViewsContainer[.OneA])
    XCTAssertNotNil(plasticViewsContainer[.OneB])
    XCTAssertNotNil(plasticViewsContainer[.Two])
    XCTAssertNotNil(plasticViewsContainer[.Four])
  }
  
  func testShouldKeepOriginalFrames() {
    
    let oneFrame = CGRect(x: 20, y: 30, width: 100, height: 100)
    let oneBFrame = CGRect(x: 10, y: 10, width: 10, height: 10)
    
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps().key(Keys.One).frame(oneFrame)) {
        [
          View(props: ViewProps().key(Keys.OneA)),
          View(props: ViewProps().key(Keys.OneB).frame(oneBFrame))
        ]
      },
      
      View(props: ViewProps().key(Keys.Two)),
      View(props: ViewProps()),
      View(props: ViewProps().key(Keys.Four)),
      ]
    
    
    let plasticViewsContainer = ViewsContainer<Keys>(rootFrame: CGRect.zero, children: hierarchy, multiplier: 1)
    let onePlaceholder = plasticViewsContainer[Keys.One]
    let oneBPlaceholder = plasticViewsContainer[Keys.OneB]
    
    
    XCTAssertEqual(onePlaceholder?.frame, oneFrame)
    XCTAssertEqual(oneBPlaceholder?.frame, oneBFrame)
  }
  
  func testShouldManageHierarchy() {
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps().key(Keys.One)) {
        [
          View(props: ViewProps().key(Keys.OneA)) {
            [
              View(props: ViewProps().key(Keys.OneAInner)),
            ]
          }
        ]
      }
    ]
    
    
    let containerFrame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let plasticViewsContainer = ViewsContainer<Keys>(rootFrame: containerFrame, children: hierarchy, multiplier: 1)
    
    // add some initial positions
    let viewOne = plasticViewsContainer[Keys.One]!
    let viewOneA = plasticViewsContainer[Keys.OneA]!
    let viewOneAInner = plasticViewsContainer[Keys.OneAInner]!
    let root = plasticViewsContainer.rootView
    
    viewOne.coverRight(root)
    viewOne.width = .fixed(400)
    
    viewOneA.asHeader(viewOne)
    viewOneA.height = .fixed(300)
    
    viewOneAInner.asFooter(viewOneA)
    viewOneAInner.height = .fixed(100)
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: Keys.OneAInner.rawValue),
      100 - viewOneA.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: Keys.OneAInner.rawValue),
      100 - viewOneA.absoluteOrigin.y
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: Keys.OneA.rawValue),
      100 - viewOne.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: Keys.OneA.rawValue),
      100 - viewOne.absoluteOrigin.y
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: Keys.One.rawValue),
      100 - root.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: Keys.One.rawValue),
      100 - root.absoluteOrigin.y
    )
  }
  
  func testShouldManageHierarchyWithNonZeroRootOrigin() {
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps().key(Keys.One)) {
        [
          View(props: ViewProps().key(Keys.OneA)) {
            [
              View(props: ViewProps().key(Keys.OneAInner)),
              ]
          }
        ]
      }
    ]
    
    
    let containerFrame = CGRect(x: 20, y: 20, width: 1000, height: 1000)
    let plasticViewsContainer = ViewsContainer<Keys>(rootFrame: containerFrame, children: hierarchy, multiplier: 1)
    
    // add some initial positions
    let viewOne = plasticViewsContainer[Keys.One]!
    let viewOneA = plasticViewsContainer[Keys.OneA]!
    let viewOneAInner = plasticViewsContainer[Keys.OneAInner]!
    let root = plasticViewsContainer.rootView
    
    viewOne.coverRight(root)
    viewOne.width = .fixed(400)
    
    viewOneA.asHeader(viewOne)
    viewOneA.height = .fixed(300)
    
    viewOneAInner.asFooter(viewOneA)
    viewOneAInner.height = .fixed(100)
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: Keys.OneAInner.rawValue),
      100 - viewOneA.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: Keys.OneAInner.rawValue),
      100 - viewOneA.absoluteOrigin.y
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: Keys.OneA.rawValue),
      100 - viewOne.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: Keys.OneA.rawValue),
      100 - viewOne.absoluteOrigin.y
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: Keys.One.rawValue),
      100 - root.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: Keys.One.rawValue),
      100 - root.absoluteOrigin.y
    )
  }


  func testShouldManageHierarchyWithoutKeys() {
    
    let oneAFrame = CGRect(x: 10, y: 10, width: 200, height: 200)
    
    let hierarchy: [AnyNodeDescription] = [
      View(props: ViewProps().key(Keys.One)) {
        [
          View(props: ViewProps().frame(oneAFrame)) {
            [
              View(props: ViewProps().key(Keys.OneAInner))
            ]
          }
        ]
      }
    ]
    
    let containerFrame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    let plasticViewsContainer = ViewsContainer<Keys>(rootFrame: containerFrame, children: hierarchy, multiplier: 1)
    
    // add some initial positions
    let viewOne = plasticViewsContainer[Keys.One]!
    let viewOneAInner = plasticViewsContainer[Keys.OneAInner]!
    let root = plasticViewsContainer.rootView
    
    viewOne.coverRight(root)
    viewOne.width = .fixed(400)
    
    viewOneAInner.asFooter(viewOne)
    viewOneAInner.height = .fixed(100)
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(100, inCoordinateSystemOfParentOfKey: Keys.One.rawValue),
      100 - root.absoluteOrigin.x
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(100, inCoordinateSystemOfParentOfKey: Keys.One.rawValue),
      100 - root.absoluteOrigin.y
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getXCoordinate(600, inCoordinateSystemOfParentOfKey: Keys.OneAInner.rawValue),
      -10
    )
    
    XCTAssertEqual(
      plasticViewsContainer.getYCoordinate(900, inCoordinateSystemOfParentOfKey: Keys.OneAInner.rawValue),
      890
    )
  }
}