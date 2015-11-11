//
//  VLDProfileTests.swift
//  Velad
//
//  Created by Renzo Crisostomo on 26/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import Quick
import Nimble

class VLDProfileTests: QuickSpec {
    override func spec() {
        describe("VLDProfile") {
            it("should map properties") {
                let profile = VLDProfile()
                profile.name = "Renzo"
                profile.circle = "Home"
                profile.group = "Lima"
                expect(profile.name).to(equal("Renzo"))
                expect(profile.circle).to(equal("Home"))
                expect(profile.group).to(equal("Lima"))
            }
        }
    }
}
