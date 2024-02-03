//
//  PlacesVC.swift
//  Just Walk
//
//  Created by Hassan Mayers on 1/1/24.

import UIKit
import SDWebImage
import SafariServices
import FirebaseFirestore

protocol PlacesVCDelegate: AnyObject {
    func didSaveOrUnsavePlace()
}

class PlacesVC: UIViewController {
    
    weak var delegate: PlacesVCDelegate?
        
    var places = [Place]()
    var currentPlace: Place?
    
    convenience init(place: Place, currentIndex: Int) {
        self.init()
        self.currentIndex = currentIndex
        fetchPlacesForRegionSelected()
        updateUI(with: place, currentIndex: currentIndex)
    }
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPlacesForRegionSelected()
        print("The current index is: \(currentIndex)")
        print("Is tapped is currently: \(isTapped)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        fetchPlacesForRegionSelected()
    }
    
    // MARK: - UI Components
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        addViews()
        setupUIConstraints()
        
        //Gesture for placeImageView (image of the place being viewed)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        placeImageView.addGestureRecognizer(gesture)
        
        // Gseture for directions label
        let directionsTapGesture = UITapGestureRecognizer(target: self, action: #selector(directionsLabelTapped))
        directionsLabel.addGestureRecognizer(directionsTapGesture)
    }
    
    private lazy var placeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.image = UIImage(named: "white_square")
        iv.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        iv.addGestureRecognizer(gesture)
        return iv
    }()
    
    private let placeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    let regionView = RegionView()
    
    private lazy var directionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Directions"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(directionsLabelTapped))
        label.addGestureRecognizer(gesture)
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemBlue
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        btn.layer.cornerRadius = 10
        return btn
    }()
    var isTapped = false
    var isLiked = false
    private lazy var likeImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "heart")
        iv.tintColor = .gray
        iv.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapLike))
        iv.addGestureRecognizer(gesture)
        return iv
    }()
    
    private func addViews() {
        view.addSubview(placeImageView)
        view.addSubview(placeNameLabel)
        view.addSubview(regionView)
        view.addSubview(directionsLabel)
        view.addSubview(nextButton)
        view.addSubview(likeImage)
    }
    
    private func setupUIConstraints() {
        NSLayoutConstraint.activate([
            placeImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            placeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            placeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            placeImageView.heightAnchor.constraint(equalToConstant: 300),
            
            placeNameLabel.topAnchor.constraint(equalTo: placeImageView.bottomAnchor, constant: 12),
            placeNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeNameLabel.widthAnchor.constraint(equalToConstant: 350),
            placeNameLabel.heightAnchor.constraint(equalToConstant: 54),
            
            regionView.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: 0),
            regionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            regionView.heightAnchor.constraint(equalToConstant: 48),
            
            directionsLabel.topAnchor.constraint(equalTo: regionView.bottomAnchor, constant: 12),
            directionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            directionsLabel.widthAnchor.constraint(equalToConstant: 300),
            directionsLabel.heightAnchor.constraint(equalToConstant: 24),
            
            nextButton.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor, constant: 24),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nextButton.trailingAnchor.constraint(equalTo: likeImage.leadingAnchor, constant: -12),
            nextButton.heightAnchor.constraint(equalToConstant: 48),
            
            likeImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            likeImage.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor),
            likeImage.heightAnchor.constraint(equalToConstant: 38),
            likeImage.widthAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    //MARK: - Networking
    var selectedRegion: String = ""
    var placesForSelectedRegion: [Place] = []
    var currentIndex: Int = 0
    
    private func fetchPlacesForRegionSelected() {
        FirebaseServices.fetchPlaces(for: selectedRegion) { [weak self] place in
            guard let strongSelf = self else { return }
            strongSelf.places = place
            self?.placesForSelectedRegion = place
            if strongSelf.currentIndex < place.count {
                let currentPlace = place[strongSelf.currentIndex]
                strongSelf.updateUI(with: currentPlace, currentIndex: strongSelf.currentIndex)
            }
        }
    }
    
    public func updateUI(with place: Place, currentIndex: Int) {
        self.currentIndex = currentIndex
        placeNameLabel.text = place.name
        regionView.setFor(region: place.region)
        if let url = URL(string: place.imageURL) {
            URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                guard let imageData = data, let image = UIImage(data: imageData) else { return }

                DispatchQueue.main.async {
                    self?.placeImageView.image = image
                    self?.updateLikeImageColor()
                }
            }.resume()
        }
    }

    // MARK: - Functions

    private func savePlaceToUserDefaults(place: Place, currentIndex: Int, isTapped: Bool) {
        var savedPlaces = UserDefaults.standard.array(forKey: "SavedPlaces") as? [[String: Any]] ?? []
        
        let placeData: [String: Any] = [
            "name": place.name,
            "imageURL": place.imageURL,
            "region": place.region,
            "docID": place.docID,
            "url": place.url,
            "placeID": place.placeID,
            "currentIndex": currentIndex,
            "isTapped": isTapped
        ]
        
        // Check if the place is already saved
        let isAlreadySaved = savedPlaces.contains { savedPlace in
            guard let docID = savedPlace["docID"] as? String else { return false }
            return docID == place.docID
        }
        
        if !isAlreadySaved {
            savedPlaces.append(placeData)
            UserDefaults.standard.set(savedPlaces, forKey: "SavedPlaces")
            UserDefaults.standard.synchronize()
            print("SavedPlaces is \(savedPlaces) & place data is \(placeData)")
        } else {
            print("Place is already saved")
        }
    }
    
    private func removePlaceFromSavedPlaces() {
        var savedPlaces: [[String: Any]] = []
        savedPlaces = UserDefaults.standard.array(forKey: "SavedPlaces") as? [[String: Any]] ?? []
        print("Current Index is: \(currentIndex)")
    }
    
    private func removePlaceFromUserDefaults(place: Place) {
        var savedPlaces = UserDefaults.standard.array(forKey: "SavedPlaces") as? [[String: Any]] ?? []

        // Find the index of the place to be removed
        if let index = savedPlaces.firstIndex(where: {
            ($0["docID"] as? String) == place.docID
        }) {
            savedPlaces.remove(at: index)
            UserDefaults.standard.set(savedPlaces, forKey: "SavedPlaces")
            UserDefaults.standard.synchronize()
            print("Removed place. Updated SavedPlaces is \(savedPlaces)")
            print("CURRENT IS TAPPED IS NOW: \(isTapped)")
        } else {
            print("Place not found in SavedPlaces")
        }
    }
    
    private func updateLikeImageColor() {
        let currentPlace = placesForSelectedRegion[currentIndex]
        let savedPlaces = UserDefaults.standard.array(forKey: "SavedPlaces") as? [[String: Any]] ?? []
        
        // Check if the current place is already saved
        let isAlreadySaved = savedPlaces.contains { savedPlace in
            guard let docID = savedPlace["docID"] as? String else { return false }
            return docID == currentPlace.docID
        }
        
        if isAlreadySaved {
            likeImage.image = UIImage(systemName: "heart.fill")
            likeImage.tintColor = .red
        } else {
            likeImage.image = UIImage(systemName: "heart")
            likeImage.tintColor = .gray
        }
    }
    
    private func openGoogleMaps() {
        let currentPlace = placesForSelectedRegion[currentIndex]
        guard let googleMapsAppURL = URL(string: "comgooglemaps://"),
             let placeURL = createPlaceURL(currentPlace: currentPlace) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(googleMapsAppURL) {
            UIApplication.shared.open(placeURL)
        } else {
            let safariVC = SFSafariViewController(url: placeURL)
            present(safariVC, animated: true)
        }
    }
    
    private func createPlaceURL(currentPlace: Place) -> URL? {
        let baseURL = "https://www.google.com/maps/search/?api=1&query=''&query_place_id=\(currentPlace.placeID)"
        guard let url = URL(string: baseURL) else { return nil }
        return url
    }

    // MARK: - Selectors

    @objc func didTapNext() {
        // Logic to display the next place
        currentIndex += 1
        if currentIndex >= placesForSelectedRegion.count {
            currentIndex = 0
        }
        fetchPlacesForRegionSelected()
    }
    
    @objc func didTapLike() {
        let currentPlace = placesForSelectedRegion[currentIndex]

        // Retrieve saved places
        let savedPlaces = UserDefaults.standard.array(forKey: "SavedPlaces") as? [[String: Any]] ?? []

        // Check if the current place is already saved
        let isAlreadySaved = savedPlaces.contains { savedPlace in
            guard let docID = savedPlace["docID"] as? String else { return false }
            return docID == currentPlace.docID
        }
        
//        let isAlreadySaved = savedPlaces.contains { savedPlace in
//            guard let currentIndex = savedPlace["currentIndex"] as? String else { return false }
//            return currentIndex == currentIndex
//        }
        isTapped = !isTapped
        if isAlreadySaved {
            // Place is already saved, so remove it
            removePlaceFromUserDefaults(place: currentPlace)
            likeImage.image = UIImage(systemName: "heart")
            likeImage.tintColor = .gray
            isTapped = false
            print("isTapped is now: \(isTapped)")
        } else {
            // Place is not saved, so save it
            savePlaceToUserDefaults(place: currentPlace, currentIndex: currentIndex, isTapped: isTapped)
            likeImage.image = UIImage(systemName: "heart.fill")
            likeImage.tintColor = .red
            isTapped = true
            print("isTapped is now: \(isTapped)")
        }
        delegate?.didSaveOrUnsavePlace()
    }
    
    @objc func didTapImage() {
        let currentPlace = placesForSelectedRegion[currentIndex]
        if let url = URL(string: currentPlace.url) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }
    }
    
    @objc func directionsLabelTapped() {
        openGoogleMaps()
        print("DEBUG: Directions label has been tapped!!!!")
        let currentPlace = placesForSelectedRegion[currentIndex]
        print("Place ID is:\(currentPlace.placeID)")
    }
}

