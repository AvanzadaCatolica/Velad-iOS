//
//  NSDateVLDAdditionsTests.swift
//  Velad
//
//  Created by Renzo Crisostomo on 26/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import Quick
import Nimble

class NSDateVLDAdditionsTests: QuickSpec {

    override func spec() {
        describe("NSDate+VLDAdditions") {
            it("should be today") {
                let today = NSDate()
                expect(today.vld_isToday()).to(beTrue())
            }
            it("should return 16/09/1990 as start of the week") {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let date = dateFormatter.dateFromString("20/09/1990")
                let startOfTheWeek = dateFormatter.dateFromString("16/09/1990")
                expect(date?.vld_startOfTheWeek()).to(equal(startOfTheWeek))
            }
            it("should return as weekday symbol") {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let date = dateFormatter.dateFromString("20/09/1990")
                expect(date?.vld_weekdaySymbol()).to(equal("jueves"))
            }
            it("should be same day") {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                let firstDate = dateFormatter.dateFromString("20/09/1990 12:00")
                let secondDate = dateFormatter.dateFromString("20/09/1990 14:00")
                expect(firstDate?.vld_isSameDay(secondDate)).to(beTrue())
            }
        }
    }
    
}
