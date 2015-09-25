//
//  VLDWeekdayArrayValidatorTests.swift
//  Velad
//
//  Created by Renzo Crisostomo on 25/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import Nimble
import Quick

class VLDWeekdayArrayValidatorTests: QuickSpec {

    override func spec() {
        describe("VLDWeekdayArrayValidator") {
            it("should validad a selected value") {
                let validator = VLDWeekdayArrayValidator.init()
                let formRowDescriptor = XLFormRowDescriptor(tag: "", rowType: "")
                formRowDescriptor.value = ["Lunes"]
                let status = validator.isValid(formRowDescriptor)
                expect(status.isValid).to(equal(true))
            }
        }
    }

}
