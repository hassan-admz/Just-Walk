//
//  SavedPlacesVC.swift
//  Just Walk
//
//  Created by Hassan Mayers on 31/12/23.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class SavedPlacesVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedPlaces()
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
}

extension SavedPlacesVC: UITableViewDelegate, UITableViewDataSource, PlacesVCDelegate {
    
    func didSaveOrUnsavePlace() {
        loadSavedPlaces()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SavedPlacesTableViewCell.identifier, for: indexPath) as! SavedPlacesTableViewCell
        let placeData = savedPlaces[indexPath.row]
        
        if let savedPlace = Place(dictionary: placeData), let currentIndex = placeData["currentIndex"] as? Int {
            cell.setTitle(with: savedPlace.name)
            cell.setImage(with: savedPlace.imageURL)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
//         Deselect the row
        self.tableView.deselectRow(at: indexPath, animated: true)
        guard let currentIndex = savedPlaces[indexPath.row]["currentIndex"] as? Int else {
            return
        }
        
        let destinationVC = PlacesVC()
        destinationVC.delegate = self
        let selectedRegion = savedPlaces[indexPath.row]["region"] as! String
        destinationVC.currentIndex = currentIndex
        destinationVC.selectedRegion = selectedRegion

        let nav = UINavigationController(rootViewController: destinationVC)
        present(nav, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
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

