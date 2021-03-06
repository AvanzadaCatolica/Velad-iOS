//
//  UnitTests.swift
//  UnitTests
//
//  Created by Renzo Crisostomo on 24/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import Nimble
import Quick

class VLDWeekdayArrayValueTransformerTests: QuickSpec {

    override func spec() {
        describe("VLDWeekdayArrayValueTrasformer") {
            it("should transform correctly plural days count") {
                let days = NSDateFormatter().weekdaySymbols
                let transformer = VLDWeekdayArrayValueTrasformer()
                let transformedValue = transformer.transformedValue(days) as! String
                expect(transformedValue).to(equal("7 días"))
            }

            it("should transform correctly singular day count") {
                let days = NSDateFormatter().weekdaySymbols
                let transformer = VLDWeekdayArrayValueTrasformer()
                let transformedValue = transformer.transformedValue(days.first) as! String
                expect(transformedValue).to(equal("Sunday"))
            }
        }

    }
    
}
