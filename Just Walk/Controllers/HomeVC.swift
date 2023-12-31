//
//  HomeVC.swift
//  Just Walk
//
//  Created by user on 31/12/23.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Data for Collection View Cells
    
    private var images: [UIImage] = []
    private var titleText: [String] = [
        "North",
        "West",
        "South",
        "East",
        "North-East",
        "Pulau Ubin"
    ]
    
    // MARK: - UI Components
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Regions"
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 24)]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        setupCollectionViewConstraints()
        
        for _ in 0...5 {
            images.append(UIImage(named: "purple_square")!)
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupCollectionViewConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        return collectionView
    }()
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            fatalError("Failed to dequeue CollectionView cell in HomeVC")
        }
        
        let image = self.images[indexPath.row]
        let titleText = self.titleText[indexPath.row]
        cell.configure(with: image, and: titleText)
        
        return cell
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.width/2) - 25
        
        return CGSize(width: width, height: 170)
    }
    
    // Vertical Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    // Horizontal Spcing
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
}
