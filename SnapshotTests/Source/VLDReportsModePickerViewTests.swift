//
//  VLDReportsModePickerViewTests.swift
//  Velad
//
//  Created by Renzo Crisostomo on 25/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import FBSnapshotTestCase

class VLDReportsModePickerViewTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testReportsModePickerViewWeekly() {
        let emptyView = VLDReportsModePickerView(mode: .Weekly)
        emptyView.frame = CGRectMake(0, 0, 320, 60)
        FBSnapshotVerifyView(emptyView)
    }

    func testReportsModePickerViewMonthly() {
        let emptyView = VLDReportsModePickerView(mode: .Monthly)
        emptyView.frame = CGRectMake(0, 0, 320, 60)
        FBSnapshotVerifyView(emptyView)
    }

}