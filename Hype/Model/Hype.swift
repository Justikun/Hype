//
//  Hype.swift
//  Hype
//
//  Created by Justin Lowry on 1/10/22.
//

import Foundation
import CloudKit

struct HypeConstants {
    static let recordTypeKey = "Hype"
    fileprivate static let bodyKey = "body"
    fileprivate static let timestamp = "timestamp"
}

class Hype {
    
    var body: String
    var timestamp: Date
    
    init(body: String, timestamp: Date = Date()) {
        self.body = body
        self.timestamp = timestamp
    }
    
} // End of class

extension CKRecord {
    /**
     Packaging out Hype model properties to be stored in a CKRecord and saved to the cloud
     */
    convenience init(hype: Hype) {
        self.init(recordType: HypeConstants.recordTypeKey)
        self.setValuesForKeys([
            HypeConstants.bodyKey : hype.body,
            HypeConstants.timestamp : hype.timestamp
            
            
        ])
    }
} // End of extension

extension Hype {
    /**
     Taking a retrieved CKRecord and pulling out the values found to initialize our Hype model
     */
    convenience init?(ckRecord: CKRecord) {
        guard let body = ckRecord[HypeConstants.bodyKey] as? String,
              let timestamp = ckRecord[HypeConstants.timestamp] as? Date
        else { return nil }
        
        self.init(body: body, timestamp: timestamp)
    }
}
