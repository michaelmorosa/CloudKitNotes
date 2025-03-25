//
//  CloudKitNotesUITests.swift
//  CloudKitNotesUITests
//
//  Created by ec2-user on 24/03/2025.
//

import XCTest

final class CloudKitNotesUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // Set up the app before each test
        app = XCUIApplication()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app.launch() // Launch the app

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testAddNote() throws {
        // Locate the elements
        let titleTextField = app.textFields["Title"]
        let contentTextView = app.textViews["Content"]
        let saveButton = app.buttons["Save Note"]
        
        // Assert that the elements exist
        XCTAssertTrue(titleTextField.exists)
        XCTAssertTrue(contentTextView.exists)
        XCTAssertTrue(saveButton.exists)
        
        // Enter text into the fields
        titleTextField.tap()
        titleTextField.typeText("Test Note Title")
        
        contentTextView.tap()
        contentTextView.typeText("This is a test note.")
        
        // Tap the save button
        saveButton.tap()

        
        // Wait for the notification or timeout (indicating the note was saved)
        XCTAssertTrue(app.staticTexts["Note saved successfully!"].waitForExistence(timeout: 5))
    }
    
    
    

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
