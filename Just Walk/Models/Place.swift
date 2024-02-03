//
//  Place.swift
//  Just Walk
//
//  Created by Hassan Mayers on 31/12/23.
//

import Foundation

struct Place: Codable {
    let name: String
    let region: String
    let imageURL: String
    let docID: String
    let url: String
    let placeID: String
    
    // New initializer for array of dictionaries
    init?(arrayOfDictionaries: [[String: Any]]) {
        // Assuming the array contains at least one dictionary
        guard let firstDictionary = arrayOfDictionaries.first,
              let name = firstDictionary["name"] as? String,
              let region = firstDictionary["region"] as? String,
              let imageURL = firstDictionary["imageURL"] as? String,
              let docID = firstDictionary["docID"] as? String,
              let url = firstDictionary["url"] as? String,
              let placeID = firstDictionary["placeID"] as? String
        else {
            return nil
        }
        self.name = name
        self.region = region
        self.imageURL = imageURL
        self.docID = docID
        self.url = url
        self.placeID = placeID
    }
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
              let region = dictionary["region"] as? String,
              let imageURL = dictionary["imageURL"] as? String,
              let docID = dictionary["docID"] as? String,
              let url = dictionary["url"] as? String,
              let placeID = dictionary["placeID"] as? String
        else {
            return nil
        }
        self.name = name
        self.region = region
        self.imageURL = imageURL
        self.docID = docID
        self.url = url
        self.placeID = placeID
    }
    
    init(name: String, region: String, imageURL: String, docID: String, url: String, placeID: String) {
        self.name = name
        self.region = region
        self.imageURL = imageURL
        self.docID = docID
        self.url = url
        self.placeID = placeID
    }
}
