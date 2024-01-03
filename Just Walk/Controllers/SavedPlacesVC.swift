//
//  SavedPlacesVC.swift
//  Just Walk
//
//  Created by user on 31/12/23.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class SavedPlacesVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadSavedPlaces()
        print("Current saved places are: \(savedPlaces)")
        //        fetchSavedPlaces()
    }
    
    // MARK: - UI Components
    
    var savedPlaces: [[String: Any]] = []
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
        navigationItem.title = "Saved Places"
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 24)]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(SavedPlacesTableViewCell.self, forCellReuseIdentifier: SavedPlacesTableViewCell.identifier)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    // MARK: - Functions
    
    private func loadSavedPlaces() {
        savedPlaces = UserDefaults.standard.array(forKey: "SavedPlaces") as? [[String: Any]] ?? []
        tableView.reloadData()
    }
    
    private func removePlaceFromUserDefaults(place: Place) {
        
        var savedPlaces = UserDefaults.standard.array(forKey: "SavedPlaces") as? [[String: Any]] ?? []
        
        if let index = savedPlaces.firstIndex(where: { ($0["name"] as? String) == place.name && ($0["imageURL"] as? String) == place.imageURL }) {
            savedPlaces.remove(at: index)
            UserDefaults.standard.set(savedPlaces, forKey: "SavedPlaces")
            UserDefaults.standard.synchronize()
        }
    }
}
    
    // MARK: - Networking


extension SavedPlacesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SavedPlacesTableViewCell.identifier, for: indexPath) as! SavedPlacesTableViewCell
        let place = savedPlaces[indexPath.row]
        
        cell.setTitle(with: place["name"] as? String ?? "")
        cell.setImage(with: place["imageURL"] as? String ?? "")
        
        
        //        let savedPlace = savedPlaces[indexPath.row]
        //
        //        cell.setTitle(with: savedPlace.name)
        //        cell.setImage(with: savedPlace.imageURL)
        
        // Fetch image asynchronously and display in the cell
        //        if let imageURL = URL(string: savedPlace.imageURL) {
        //            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
        //                if let data = data, let image = UIImage(data: data) {
        //                    DispatchQueue.main.async {
        //                        cell.setImage(with: savedPlace.imageURL)
        //                    }
        //                }
        //            }.resume()
        //        }
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let selectedPlace = savedPlaces[indexPath.row]
    //        navigateToPlacesVCWith(selectedPlace: selectedPlace)
    //    }
    //
    //    func navigateToPlacesVCWith(selectedPlace: Place) {
    //        let vc = PlacesVC(databaseService: DatabaseService())
    //        vc.currentPlace = selectedPlace
    //        navigationController?.pushViewController(vc, animated: true)
    //    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let deletedPlace = savedPlaces[indexPath.row]
//            if let place = Place(dictionary: deletedPlace) {
//                removePlaceFromUserDefaults(place: place)
//            }
            
            savedPlaces.remove(at: indexPath.row)
            UserDefaults.standard.set(savedPlaces, forKey: "SavedPlaces")
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

