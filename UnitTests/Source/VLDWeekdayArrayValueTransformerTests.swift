//
//  UnitTests.swift
//  UnitTests
//
//  Created by Renzo Crisostomo on 24/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import XCTest
import Nimble

class UnitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testTransformedValue() {
        let days = NSDateFormatter.init().weekdaySymbols;
        let transformer = VLDWeekdayArrayValueTrasformer.init()
        let transformedValue = transformer.transformedValue(days) as! String
        expect(transformedValue).to(equal("7 días"))
    }
    
}
