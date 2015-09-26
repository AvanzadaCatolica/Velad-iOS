//
//  NSStringVLDAdditionsTests.swift
//  Velad
//
//  Created by Renzo Crisostomo on 25/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import Quick
import Nimble

class NSStringVLDAdditionsTests: QuickSpec {

    override func spec() {
        describe("NSString+VLDAdditions") {
            it("should return empty") {
                let string = ""
                expect(string.vld_isEmpty()).to(beTrue())
            }
            it("should not return empty") {
                let string = "ABA"
                expect(string.vld_isEmpty()).to(beFalse())
            }
        }
    }

}
