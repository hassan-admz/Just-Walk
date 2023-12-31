//
//  DatabaseService.swift
//  Just Walk
//
//  Created by user on 31/12/23.
//

import Foundation
import FirebaseFirestore

class DatabaseService {
    
    let database = Firestore.firestore()
    
    func fetchPlaces(completion: @escaping (Result<Place, Error>) -> Void) {
        database.collection("places").order(by: "docID", descending: false).getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let snapshot = snapshot else {
                print("error loading snapshot")
                return
            }
            print(snapshot.documents.first)
        }
    }
}
