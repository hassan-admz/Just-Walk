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
