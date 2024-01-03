//
//  DatabaseService.swift
//  Just Walk
//
//  Created by user on 31/12/23.
//

import Foundation
import FirebaseFirestore

//protocol DatabaseServiceProtocol {
//    func fetchPlaces(completion: @escaping (Result<[Place], fetchPlaceError>) -> Void)
//}
//
//class DatabaseService: DatabaseServiceProtocol {
//    
//    let database = Firestore.firestore()
//    
//    func fetchPlaces(completion: @escaping (Result<[Place], fetchPlaceError>) -> Void) {
//        database.collection("places").order(by: "docID", descending: false).getDocuments { snapshot, error in
//            if let error = error {
//                print(error.localizedDescription)
//                completion(.failure(.NetworkError))
//            }
//            
//            guard let snapshot = snapshot else {
//                print("error loading snapshot")
//                completion(.failure(.DataError))
//                return
//            }
//            
//            let documents = snapshot.documents
//            var places = [Place]()
//            for doc in documents {
//                let data = doc.data()
//                let name = data["name"] as? String ?? ""
//                let region = data["region"] as? String ?? ""
//                let imageURL = data["imageURL"] as? String ?? ""
//                let docID = data["docID"] as? String ?? ""
//                
//                let place = Place(name: name, region: region, imageURL: imageURL, docID: docID)
//                places.append(place)
//            }
//            
//            completion(.success(places))
//        }
//    }
//}
