//
//  Up2DateUITestsLaunchTests.swift
//  Up2DateUITests
//
//  Created by Matthias Wallner-Géhri on 02.05.26.
//

import XCTest

final class Up2DateUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Keine Apps gefunden"].waitForExistence(timeout: 5))
    }
}
