//
//  AboutCanadaUITests.swift
//  AboutCanadaUITests
//
//  Created by Veera Venkata Sateesh Pasala on 11/11/20.
//  Copyright © 2020 Veera Venkata Sateesh Pasala. All rights reserved.
//

import XCTest


class AboutCanadaUITests: XCTestCase {

    override func setUpWithError() throws {

        continueAfterFailure = false
    }


    func testAboutCanadaTableView() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        ///check for number of tables
        XCTAssertEqual(app.tables.count, 1)
        
        ///check for number of buttons
        XCTAssertEqual(app.buttons.count, 0)
        
        let table = app.tables.element(boundBy: 0)
        sleep(3)
        
        ///check the numebr of cells
        XCTAssertEqual(table.cells.count, 14)
        
        ///check the navigation bar with title
        let navBar = app.navigationBars["About Canada"]
        XCTAssertTrue(navBar.exists)
        
    }

}
