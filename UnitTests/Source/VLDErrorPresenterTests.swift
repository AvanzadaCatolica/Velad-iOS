//
//  VLDErrorPresenterTests.swift
//  Velad
//
//  Created by Renzo Crisostomo on 25/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import Nimble
import Quick

class VLDErrorPresenterTests: QuickSpec {

    class VLDErrorPresenterDataSource_Mock: NSObject, VLDErrorPresenterDataSource {

        var mockData: Dictionary<String, Int> = Dictionary()

        func viewControllerForErrorPresenter(presenter: VLDErrorPresenter!) -> UIViewController! {
            let key = NSStringFromSelector("viewControllerForErrorPresenter:")
            if let count = mockData[key] {
                mockData[key] = count + 1
            } else {
                mockData[key] = 1
            }
            return nil
        }

        func callCountForSelector(selector: Selector) -> Int {
            let key = NSStringFromSelector(selector)
            if let count = mockData[key] {
                return count
            } else {
                return 0
            }
        }

    }

    override func spec() {
        describe("VLDErrorPresenterDataSource") {
            it("should call `viewControllerForErrorPresenter:` during `presentError:`") {
                let dataSource = VLDErrorPresenterDataSource_Mock()
                let error = NSError(domain: "", code: 0, userInfo: ["NSLocalizedDescription": ""])
                let errorPresenter = VLDErrorPresenter(dataSource: dataSource)
                errorPresenter.presentError(error)
                expect(dataSource.callCountForSelector("viewControllerForErrorPresenter:")).to(equal(1))
            }
        }
    }

}