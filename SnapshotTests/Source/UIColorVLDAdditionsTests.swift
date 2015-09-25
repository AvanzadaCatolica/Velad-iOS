//
//  UIColorVLDAdditionsTests.swift
//  Velad
//
//  Created by Renzo Crisostomo on 25/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import FBSnapshotTestCase

class UIColorVLDAdditionsTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testUIColorVLDMainColor() {
        let view = UIView(frame: CGRectMake(0, 0, 100, 100))
        view.backgroundColor = UIColor.vld_mainColor()
        FBSnapshotVerifyView(view)
    }

}


