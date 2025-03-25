//
//  ContentView.swift
//  CloudKitNotes
//
//  Created by ec2-user on 24/03/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // Initialize a state object that listens for published var changes in CloudKitHelper class.
    @StateObject private var cloudKitHelper = CloudKitHelper()
    
    // Initialize state variable for title, conent, and bool for showing add note sheet
    @State private var newNoteTitle = ""
    @State private var newNotecontent = ""
    @State private var isShowingAddNoteSheet = false
    @State private var successMessage: String = "" // State property to hold success message
    @State private var refreshSuccessMessage: String = "" // State property ot hold success message for refresh button click

    // body content
    var body: some View {
        
        // Navigation view
        NavigationView {
            // Display vertical stack of all the notes
            VStack {
                List(cloudKitHelper.notes) { note in
                    VStack(alignment: .leading) {
                        Text(note.title)
                            .font(.headline)
                        Text(note.content)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                if !successMessage.isEmpty {
                    Text(successMessage)
                        .accessibilityIdentifier("SuccessMessage")
                        .foregroundColor(.green)
                        .padding()
                }
                
                // Display a vertical stack that lets a user add a new note
                VStack(alignment: .leading, spacing: 10) {
                    TextField("Enter note title", text: $newNoteTitle)
                        .accessibilityIdentifier("Title")
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextEditor(text: $newNotecontent)
                        .accessibilityIdentifier("Content")
                        .frame(height: 100)
                        .border(Color.gray, width: 1)
                        .padding(.horizontal)
                    
                    Button(action: {
                        guard !newNoteTitle.isEmpty, !newNotecontent.isEmpty else {return}
                        // Save a new note when clicking the Save Note button
                        cloudKitHelper.saveNote(title: newNoteTitle, content: newNotecontent) { error in
                            if (error == nil) {
                                successMessage = "Note saved successfully!"
                                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                    successMessage = ""
                                }
                            }
                        }
                        newNoteTitle = ""
                        newNotecontent = ""
                    }){
                        Text("Save Note")
                            .accessibilityIdentifier("Save Note")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationTitle("Cloud Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { // Fetch the notes when clicking the refresh button
                        cloudKitHelper.fetchNotes { _, _ in
                            print("Fetched notes after saving.")
                     }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .onAppear {
                cloudKitHelper.fetchNotes { _, _ in
                    print("Fetched notes after saving.")
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
