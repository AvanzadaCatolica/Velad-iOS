//
//  UnitTests.swift
//  UnitTests
//
//  Created by Renzo Crisostomo on 24/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import XCTest
import Nimble
import Quick

class UnitTests: QuickSpec {

    override func spec() {
        describe("VLDWeekdayArrayValueTrasformer") {
            it("should transform correctly plural days count") {
                let days = NSDateFormatter.init().weekdaySymbols
                let transformer = VLDWeekdayArrayValueTrasformer.init()
                let transformedValue = transformer.transformedValue(days) as! String
                expect(transformedValue).to(equal("7 días"))
            }

            it("should transform correctly singular day count") {
                let days = NSDateFormatter.init().weekdaySymbols
                let transformer = VLDWeekdayArrayValueTrasformer.init()
                let transformedValue = transformer.transformedValue(days.first) as! String
                expect(transformedValue).to(equal("Sunday"))
            }
        }

    }
    
}
