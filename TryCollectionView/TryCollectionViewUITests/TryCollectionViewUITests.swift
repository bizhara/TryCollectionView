//
//  TryCollectionViewUITests.swift
//  TryCollectionViewUITests
//
//  Created by kazuaki on 2020/07/23.
//  Copyright © 2020 KH. All rights reserved.
//

import XCTest

final class TryCollectionViewUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testContentIsDisplayed() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["TryCollectionView"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["1: セルタイトル"].waitForExistence(timeout: 5))

        let targetCellTitle = app.staticTexts["10: 1行に入り切らないセルタイトルにすると末尾が省略表示になる設定だがどうだろうか？"]
        let list = app.collectionViews.firstMatch

        for _ in 0..<5 where !targetCellTitle.exists {
            list.swipeUp()
        }

        XCTAssertTrue(targetCellTitle.waitForExistence(timeout: 5))
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
