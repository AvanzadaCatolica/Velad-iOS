//
//  VLDDateIntervalPickerViewTests.swift
//  Velad
//
//  Created by Renzo Crisostomo on 25/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import FBSnapshotTestCase

class VLDDateIntervalPickerViewTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testDateIntervalPickerViewWeekly() {
        let dateIntervalPickerView = VLDDateIntervalPickerView(type: .Weekly)
        dateIntervalPickerView.frame = CGRectMake(0, 0, 320, 60)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateIntervalPickerView.setSelectedStartDate(dateFormatter.dateFromString("20/09/1990"))
        FBSnapshotVerifyView(dateIntervalPickerView)
    }

    func testDateIntervalPickerViewMonthly() {
        let dateIntervalPickerView = VLDDateIntervalPickerView(type: .Monthly)
        dateIntervalPickerView.frame = CGRectMake(0, 0, 320, 60)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateIntervalPickerView.setSelectedStartDate(dateFormatter.dateFromString("01/09/1990"))
        FBSnapshotVerifyView(dateIntervalPickerView)
    }

}
