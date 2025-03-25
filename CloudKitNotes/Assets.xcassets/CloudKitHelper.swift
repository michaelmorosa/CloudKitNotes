//
//  CloudKitHelper.swift
//  CloudNotes
//
//  Created by ec2-user on 21/03/2025.
//
import Foundation
import CloudKit

// Initialize the fields and types of Note.
struct Note: Identifiable {
    var id: CKRecord.ID
    var title: String
    var content: String
    var createdAt: Date
}

class CloudKitHelper: ObservableObject {
    
    // Initialize a published array called notes of type Note
    @Published var notes: [Note] = []
    
    // Initialize the database object of type CKDatabase
    private var database: CKDatabase
    
    init() {
        self.database = CKContainer.default().privateCloudDatabase
    }
    
    // Fetch notes from CloudKit
    func fetchNotes() {
        
        print("Fetching notes from CloudKit...")
        
        // Define the query for record type Note with an empty predicate
        let query = CKQuery(recordType: "Note", predicate: NSPredicate(value:true))
        
        // Initialize a sort descriptor for when the query is ran
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        
        // Add on the sort descriptor to the query
        query.sortDescriptors = [sortDescriptor]
        
        // Perform the query in the default zone (nil)
        database.perform(query, inZoneWith: nil) { records, error in
            // if the query succeeded an array of records is returned. if not, an error is returned
            
            // If error contains an actual value, not nil, it goes into the if statement and exits early
            if let error = error {
                print("Error fetching notes: \(error)")
                return
            }
            
            // We exit the function early if records does not contain an actual value (not nil)
            guard let records = records else {
                print("No records found.")
                return
            }
            
            // Executes updates to notes array asynchronously on the main thread
            DispatchQueue.main.async {
                
                // Map each returned record to a Note object and set the result to the published notes array
                self.notes = records.map { record in
                    print("Fetched \(records.count) notes.")
                    return Note(
                        id: record.recordID,
                        title: record["title"] as? String ?? "",
                        content: record["content"] as? String ?? "",
                        createdAt: record.creationDate ?? Date()
                    )
                }
                // print("Updated notes array: \(self.notes)")
            }
        }
    }
    
    // Save a new note to CloudKit
    func saveNote(title: String, content: String) {
        // Print a debugging statement
        print("saveNote is called with title: \(title), content: \(content)")
        
        // Initialize a CKRecord of type Note
        let noteRecord = CKRecord(recordType: "Note")
        
        // File the record with the parameters passed in from the content view
        noteRecord["title"] = title
        noteRecord["content"] = content
        noteRecord["createdAt"] = Date()
        
        // Save the record to the private database in the default CKContainer
        database.save(noteRecord) { record, error in
            
            // Exit early if error has an actual value
            if let error = error {
                print("Error saving note; \(error)")
                return
            }
            
            // After saving, asynchronously fetch all the notes on the main thread
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("Note saved successfully!")
                self.fetchNotes()
            }
        }
        
    }
    
}
