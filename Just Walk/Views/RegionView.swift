//
//  RegionView.swift
//  Just Walk
//
//  Created by user on 1/1/24.
//

import UIKit

class RegionView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    // MARK: - UI Components
    
    private func configureUI() {
        addSubview(regionLabel)
        addSubview(circleImageView)
        setupUIConstraints()
    }
    
    let regionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Region"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let circleImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "circle.fill")
        return iv
    }()
    
    func setupUIConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            regionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            regionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            regionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            regionLabel.heightAnchor.constraint(equalToConstant: 24),
            
            circleImageView.trailingAnchor.constraint(equalTo: regionLabel.leadingAnchor, constant: -8),
            circleImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleImageView.widthAnchor.constraint(equalToConstant: 20),
            circleImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setFor(region: String) {
        regionLabel.text = region
        switch region {
        case "North":
            regionLabel.textColor = .systemRed
            circleImageView.tintColor = .systemRed
        case "West":
            regionLabel.textColor = .systemGreen
            circleImageView.tintColor = .systemGreen
        case "South":
            regionLabel.textColor = .systemRed
            circleImageView.tintColor = .systemRed
        case "East":
            regionLabel.textColor = .systemGreen
            circleImageView.tintColor = .systemGreen
        case "North-East":
            regionLabel.textColor = .systemPurple
            circleImageView.tintColor = .systemPurple
        default:
            regionLabel.textColor = .systemBlue
            circleImageView.tintColor = .systemBlue
        }
    }
    
    // Required initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
