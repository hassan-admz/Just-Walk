//
//  PlacesVC.swift
//  Just Walk
//
//  Created by user on 1/1/24.
//

import UIKit
import SDWebImage
import FirebaseFirestore

class PlacesVC: UIViewController {
    
    var places = [Place]()
    var currentPlace: Place?
    
    var databaseService: DatabaseServiceProtocol?
    
    init(databaseService: DatabaseServiceProtocol) {
        self.databaseService = databaseService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPlacesForSelectedRegion()
    }
    
    // MARK: - UI Components
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        addViews()
        setupUIConstraints()
    }
    
    private let placeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.image = UIImage(named: "white_square")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        iv.addGestureRecognizer(gesture)
        return iv
    }()
    
    private let placeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Singapore"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    let regionView = RegionView()
    
    private let directionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Directions"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
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
    
    private func addViews() {
        view.addSubview(placeImageView)
        view.addSubview(placeNameLabel)
        view.addSubview(regionView)
        view.addSubview(directionsLabel)
        view.addSubview(nextButton)
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
            
            regionView.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: 6),
            regionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            regionView.heightAnchor.constraint(equalToConstant: 48),
            
            directionsLabel.topAnchor.constraint(equalTo: regionView.bottomAnchor, constant: 12),
            directionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            directionsLabel.widthAnchor.constraint(equalToConstant: 300),
            directionsLabel.heightAnchor.constraint(equalToConstant: 24),
            
            nextButton.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor, constant: 24),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            nextButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    //MARK: - Networking
    var selectedRegion: String = ""
    var placesForSelectedRegion: [Place] = []
    var currentIndex: Int = 0
    
    private func fetchPlacesForSelectedRegion() {
        let db = Firestore.firestore()
        db.collection("places").whereField("region", isEqualTo: selectedRegion).getDocuments { [weak self](querySnapshot, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Error fetching places for selected region: \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let imageURL = data["imageURL"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let region = data["region"] as? String ?? ""
                    let docID = data["docID"] as? String ?? ""
                    let place = Place(name: name, region: strongSelf.selectedRegion, imageURL: imageURL, docID: docID)
                    strongSelf.placesForSelectedRegion.append(place)
                    // Process fetched data (e.g., display in UIImageView and UILabels)
                    if let url = URL(string: imageURL) {
                        URLSession.shared.dataTask(with: url) { (data, _, _) in
                            if let data = data {
                                DispatchQueue.main.async {
                                    strongSelf.placeImageView.image = UIImage(data: data)
                                }
                            }
                        }.resume()
                    }
                    strongSelf.placeNameLabel.text = name
                    strongSelf.regionView.setFor(region: region)
                }
            }
        }
    }
    
    private func fetchPlaces() {
        
        databaseService?.fetchPlaces { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let success):
                strongSelf.places = success
            case .failure(let failure):
                print("error")
                print(failure.localizedDescription)
            }
        }
    }
    
    private func updateCurrentPlaceFor(currentPlace: Place) {
        
        // Image
        let urlString = currentPlace.imageURL
        let url = URL(string: urlString)
        placeImageView.sd_setImage(with: url)
        
        // Name
        placeNameLabel.text = currentPlace.name
        
        // Region
        
        
    }
    
    // MARK: - Selectors
    
    @objc func didTapNext() {
        guard !placesForSelectedRegion.isEmpty else {
            placeImageView.image = UIImage(systemName: "questionmark")
            placeNameLabel.text = "No places available"
            return
        }
        // Logic to display the next place
        currentIndex = (currentIndex + 1) % placesForSelectedRegion.count
        let nextPlace = placesForSelectedRegion[currentIndex]
        
        // Update UI based on nextPlace's data
        if let url = URL(string: nextPlace.imageURL) {
            URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                guard let self = self, let data = data else { return }
                DispatchQueue.main.async {
                    self.placeImageView.image = UIImage(data: data)
                    self.placeNameLabel.text = nextPlace.name
                    self.regionView.setFor(region: nextPlace.region)
                }
            }.resume()
        }
        
//        if !places.isEmpty {
//            self.currentPlace = places.randomElement()
//            guard let currentPlace = currentPlace else { return }
//            updateCurrentPlaceFor(currentPlace: currentPlace)
//        }
    }
    
    @objc func didTapImage() {
        print("image tapped")
    }
}
