//
//  SnapshotTests.swift
//  SnapshotTests
//
//  Created by Renzo Crisostomo on 25/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import FBSnapshotTestCase

class VLDDatePickerViewTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testDatePickerView() {
        let datePickerView = VLDDatePickerView(frame: CGRectMake(0, 0, 320, 60));
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        datePickerView.setSelectedDate(dateFormatter.dateFromString("20/09/1990"))
        datePickerView.updateSelectedDateLabel()
        FBSnapshotVerifyView(datePickerView)
    }

}
