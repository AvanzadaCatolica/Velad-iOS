//
//  VLDBasicPointTests.swift
//  Velad
//
//  Created by Renzo Crisóstomo on 11/11/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import Quick
import Nimble

class VLDBasicPointTests: QuickSpec {
    override func spec() {
        describe("VLDBasicPoint") {
            it("should map properties") {
                let UUID = NSUUID().UUIDString
                let basicPoint = VLDBasicPoint()
                basicPoint.UUID = UUID
                basicPoint.name = "Punto Básico"
                basicPoint.enabled = true
                basicPoint.descriptionText = "Descripción"
                expect(basicPoint.UUID).to(equal(UUID))
                expect(basicPoint.name).to(equal("Punto Básico"))
                expect(basicPoint.enabled).to(beTrue())
                expect(basicPoint.descriptionText).to(equal("Descripción"))
            }
            
            it("should return weekday symbols correctly") {
                let basicPoint = VLDBasicPoint()
                let weekDay = VLDWeekDay()
                weekDay.name = "lunes"
                basicPoint.weekDays.addObject(weekDay)
                let symbols = basicPoint.weekDaySymbols()
                expect(symbols).to(equal(["lunes"]))
            }
            
            it("should count possibilities correctly") {
                let basicPoint = VLDBasicPoint()
                ["lunes", "martes", "miércoles"].map({ name in
                    let weekDay = VLDWeekDay()
                    weekDay.name = name
                    basicPoint.weekDays.addObject(weekDay)
                })
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let date = dateFormatter.dateFromString("19/09/2015")
                let count = basicPoint.possibleWeekDaysCountUntilWeekDaySymbol(date?.vld_weekdaySymbol())
                expect(count).to(equal(3))
            }
        }
    }
}

