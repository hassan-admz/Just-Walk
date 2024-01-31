//
//  FirebaseServices.swift
//  Just Walk
//
//  Created by user on 11/1/24.
//

import Foundation
import FirebaseFirestore

struct FirebaseServices {
    static var selectedRegion: String = ""
   
    static func fetchPlaces(for selectedRegion: String, completion: @escaping([Place]) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("places").whereField("region", isEqualTo: selectedRegion).getDocuments {(querySnapshot, error) in
            guard let querySnapshot = querySnapshot else { return }
            if let error = error {
                print("Error fetching places for selected region: \(error.localizedDescription)")
            }
            
            let places = querySnapshot.documents.map({ Place(dictionary: $0.data())! })
            completion(places)
        }
    }
}
