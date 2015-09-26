//
//  NSCalendarVLDAdditionsTests.swift
//  Velad
//
//  Created by Renzo Crisostomo on 26/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import Quick
import Nimble

class NSCalendarVLDAdditionsTests: QuickSpec {

    override func spec() {
        describe("NSCalendar+VLDAdditions") {
            it("preferred calendar should start on monday") {
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setBool(true, forKey: VLDCalendarShouldStartOnMondayKey)
                let calendar = NSCalendar.vld_preferredCalendar()
                expect(calendar.firstWeekday).to(equal(2))
                userDefaults.setBool(false, forKey: VLDCalendarShouldStartOnMondayKey)
            }
        }
    }
}
