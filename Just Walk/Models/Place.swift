//
//  Place.swift
//  Just Walk
//
//  Created by user on 31/12/23.
//

import Foundation

struct Place: Codable {
    let name: String
    let region: String
    let imageURL: String
    let docID: String
    
    // New initializer for array of dictionaries
    init?(arrayOfDictionaries: [[String: Any]]) {
        // Assuming the array contains at least one dictionary
        guard let firstDictionary = arrayOfDictionaries.first,
              let name = firstDictionary["name"] as? String,
              let region = firstDictionary["region"] as? String,
              let imageURL = firstDictionary["imageURL"] as? String,
              let docID = firstDictionary["docID"] as? String
        else {
            return nil
        }
        self.name = name
        self.region = region
        self.imageURL = imageURL
        self.docID = docID
    }
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
              let region = dictionary["region"] as? String,
              let imageURL = dictionary["imageURL"] as? String,
              let docID = dictionary["docID"] as? String
        else {
            return nil
        }
        self.name = name
        self.region = region
        self.imageURL = imageURL
        self.docID = docID
    }
    
    init(name: String, region: String, imageURL: String, docID: String) {
        self.name = name
        self.region = region
        self.imageURL = imageURL
        self.docID = docID
    }
}
