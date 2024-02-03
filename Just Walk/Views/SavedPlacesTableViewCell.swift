//
//  SavedPlacesTableViewCell.swift
//  Just Walk
//
//  Created by Hassan Mayers on 2/1/24.
//

import UIKit

class SavedPlacesTableViewCell: UITableViewCell {
    static let identifier = "SavedPlacesTableViewCell"
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    let placeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.image = UIImage(named: "purple_square")
        return iv
    }()
    
    let placeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22)
        label.text = "Helloo"
        label.textColor = .black
        return label
    }()
    
    func configureUI() {
        addSubview(placeImageView)
        addSubview(placeLabel)
        setupUIConstraints()
    }
    
    func setupUIConstraints() {
        NSLayoutConstraint.activate([
            placeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            placeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            placeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            placeImageView.widthAnchor.constraint(equalToConstant: 75),
            
            placeLabel.leadingAnchor.constraint(equalTo: placeImageView.trailingAnchor, constant: 12),
            placeLabel.centerYAnchor.constraint(equalTo: placeImageView.centerYAnchor, constant: 0),
            placeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    // MARK: - Functions
    
    public func setTitle(with text: String) {
        self.placeLabel.text = text
    }
    
    public func setImage(with urlString: String) {
        if let url = URL(string: urlString) {
            placeImageView.sd_setImage(with: url)
            self.setNeedsLayout()
        }
    }
}
