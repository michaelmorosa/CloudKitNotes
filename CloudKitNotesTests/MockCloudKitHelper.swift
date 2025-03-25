//
//  MockCloudKitHelper.swift
//  CloudKitNotes
//
//  Created by ec2-user on 24/03/2025.
//

import XCTest
@testable import CloudKitNotes
import CloudKit

class MockCloudKitHelper: CloudKitHelperProtocol {
    
    var mockNotes: [Note] = [] // Fake in-memory storage
    var shouldReturnError: Bool = false // Flag to simulat errors
    
    func fetchNotes(completion: @escaping ([Note]?, Error?) -> Void) {
        if shouldReturnError {
            completion(nil, NSError(domain: "MockCloudKitHelper", code: 1, userInfo: [NSLocalizedDescriptionKey: "Fetch error"])) // Simulate failure
        }else {
            let mockNotes = [
                Note(id: CKRecord.ID(recordName: "1"), title: "Mock Note 1", content: "Mock Content 1", createdAt: Date()),
                Note(id: CKRecord.ID(recordName: "2"), title: "Mock Note 2", content: "Mock Content 2", createdAt: Date())            ]
            completion(mockNotes, nil) // Simulate success
        }
    }
    
    func saveNote(title: String, content: String, completion: @escaping (Error?) -> Void) {
        if shouldReturnError {
            completion(NSError(domain: "MockCloudKitHelper", code: 2, userInfo: [NSLocalizedDescriptionKey: "Save error"])) // Simulate failure
        } else {
            print("Mock saveNote called with title: \(title), content: \(content)")
            completion(nil) // Simulate Success
        }
    }
}

