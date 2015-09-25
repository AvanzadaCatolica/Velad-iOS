//
//  VLDEmptyViewTests.swift
//  Velad
//
//  Created by Renzo Crisostomo on 25/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import FBSnapshotTestCase

class VLDEmptyViewTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testEmptyView() {
        let emptyView = VLDEmptyView()
        emptyView.frame = CGRectMake(0, 0, 320, 320)
        FBSnapshotVerifyView(emptyView)
    }

}