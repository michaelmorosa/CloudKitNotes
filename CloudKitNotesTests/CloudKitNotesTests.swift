//
//  CloudKitNotesTests.swift
//  CloudKitNotesTests
//
//  Created by ec2-user on 24/03/2025.
//

import XCTest
@testable import CloudKitNotes

final class CloudKitNotesTests: XCTestCase {
    
    var mockHelper: MockCloudKitHelper!
    
    override func setUp() {
        super.setUp()
        mockHelper = MockCloudKitHelper() // Initialize the mock before each test
    }


    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockHelper = nil // Clean up after each test
        super.tearDown()
    }

    func testFetchNotes_Success() {
        let mockHelper = MockCloudKitHelper()
        
        mockHelper.shouldReturnError = false // Simulate success
        
        mockHelper.fetchNotes { notes, error in
            XCTAssertNil(error) // No error expected
            XCTAssertEqual(notes?.count, 2) // Expecting 2 mock notes
        }
    }
    
    func testFetchNotes_Failure() {
        let mockHelper = MockCloudKitHelper()
        
        mockHelper.shouldReturnError = true // Simulate success
        
        mockHelper.fetchNotes { notes, error in
            XCTAssertNotNil(error) // No error expected
            XCTAssertNil(notes) // Nots should be nil on failure
        }
    }
    
    func testSaveNotes_Success() {
        let mockHelper = MockCloudKitHelper()
        
        mockHelper.shouldReturnError = false // Simulate success
        
        mockHelper.saveNote(title: "Test Note", content: "Test content") { error in         XCTAssertNil(error) // Nots should be nil on failure
        }
    }
    
    func testSaveNotes_Failure() {
        let mockHelper = MockCloudKitHelper()
        
        mockHelper.shouldReturnError = true // Simulate success
        
        mockHelper.saveNote(title: "Test Note", content: "Test content") { error in         XCTAssertNotNil(error) // Notes should not be nil on failure
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
