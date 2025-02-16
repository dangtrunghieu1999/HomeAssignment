//
//  HomeAssignmentUITests.swift
//  HomeAssignmentUITests
//
//  Created by Kai on 15/2/25.
//

import XCTest

class HomeAssignmentUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testUserListLoading() throws {
        let table = app.tables.firstMatch
        XCTAssertTrue(table.exists)
        
        // Wait for cells to load
        let cell = table.cells.firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testUserDetailNavigation() throws {
        let table = app.tables.firstMatch
        
        // Wait for cells to load
        let cell = table.cells.firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        // Tap first cell
        cell.tap()
        
        // Verify navigation
        XCTAssertTrue(app.navigationBars["User Details"].exists)
    }
    
    func testPullToRefresh() throws {
        let table = app.tables.firstMatch
        
        // Wait for initial load
        let cell = table.cells.firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        // Perform pull to refresh
        table.swipeDown()
        
        // Verify table reloaded
        XCTAssertTrue(table.cells.count > 0)
    }
}
