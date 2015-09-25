//
//  VLDSectionsViewModelTests.swift
//  Velad
//
//  Created by Renzo Crisostomo on 25/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import Quick
import Nimble

class VLDSectionsViewModelTests: QuickSpec {

    override func spec() {
        describe("VLDSectionsViewModel") {
            it("should calculate `totalCount` correctly") {
                let viewModel = VLDSectionsViewModel(sectionTitles: ["B", "C"], sections: [["ABA", "BAB"], ["CAC", "ACA"]])
                expect(viewModel.totalCount).to(equal(4))
            }
        }
    }

}