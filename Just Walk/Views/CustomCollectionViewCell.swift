//
//  CustomCollectionViewCell.swift
//  Just Walk
//
//  Created by user on 31/12/23.
//

import UIKit
import SDWebImage

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    private let myImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .white
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with image: UIImage, and text: String) {
        self.myImageView.image = image
        self.titleLabel.text = text
        self.setupUI()
    }
    
    public func configureTitle(with text: String) {
        self.titleLabel.text = text
    }
    
    public func setImage(with urlString: String) {
        if let url = URL(string: urlString) {
            myImageView.sd_setImage(with: url)
            self.setNeedsLayout()
        }
    }
    
    private func setupUI() {
        self.backgroundColor = .systemBackground
        
        self.addSubview(myImageView)
        self.addSubview(titleLabel)
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            myImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            myImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            myImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            titleLabel.topAnchor.constraint(equalTo: myImageView.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: myImageView.centerXAnchor)
        ])
        
        myImageView.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.myImageView.image = nil
        self.titleLabel.text = nil
    }
}
