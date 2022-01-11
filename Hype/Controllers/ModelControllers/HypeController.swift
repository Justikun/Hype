//
//  HypeController.swift
//  Hype
//
//  Created by Justin Lowry on 1/10/22.
//

import Foundation
import CloudKit

class HypeController {
    /// Shared instance
    static let shared = HypeController()
    /// Source of Truth array
    var hypes: [Hype] = []
    /// Constant to store our publicCloudDatabase
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD
    // Create
    func saveHype(with text: String, completion: @escaping (Bool) -> Void) {
        // init Hype object
        let newHype = Hype(body: text)
        // package new Hype object into CKRecord
        let hypeRecord = CKRecord(hype: newHype)
        // Saving a Hype record to the cloud
        publicDB.save(hypeRecord) { record, error in
            // Error Handling
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                completion(false)
                return
            }
            //Unwrapping saved record
            guard let record = record,
                  // Ensuring we can initialze a Hype from that record
                  let savedHype = Hype(ckRecord: record)
            else { completion(false) ; return }
            // Add to our SoT array
            print("Saved Hype successfully")
            self.hypes.insert(savedHype, at: 0)
            completion(true)
        }
    }
    
    // Fetch
    func fetchHypes(completion: @escaping(Bool) -> Void) {
        // Step 3 -  init requisite predicate for the query
        let predicate = NSPredicate(value: true)
        // Step 2 - Init the query for the .perform method
        let query = CKQuery(recordType: HypeConstants.recordTypeKey, predicate: predicate)
        // Step 1 - Perform a query on the database
        publicDB.perform(query, inZoneWith: nil) { records, error in
            // Error Handling
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                completion(false)
                return
            }
            // Unwrap found records
            guard let records = records else { completion(false) ; return }
            print("Fetched all Hypes")
            // Compact map through the found records to return the non nil Hype objects
            let hypes = records.compactMap { Hype(ckRecord: $0) }
            // Set out source of truth
            self.hypes = hypes
            completion(true)
            return
        }
    }
    
    
}
