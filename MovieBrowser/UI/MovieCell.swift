//
//  MovieCell.swift
//  MovieBrowser
//
//  Created by Gonzalo Fuentes on 22/11/22.
//

import UIKit

class MovieCell: UITableViewCell {
    var posterImageView = UIImageView(image: UIImage(named: "PosterPlaceholder"))
    var titleLabel = UILabel()
    
    var container = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(container)
        container.addSubview(posterImageView)
        container.addSubview(titleLabel)
        
        setupContainer()
        setupImageView()
        setupTitleLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContainer(){
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = false
        container.layer.shadowRadius = 4
        container.layer.shadowOpacity = 0.3
        container.layer.shadowColor = UIColor.gray.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        container.backgroundColor = UIColor.white
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        container.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
    }
    
    func setupImageView() {
        posterImageView.layer.cornerRadius = 10
        posterImageView.clipsToBounds = true
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 9/16).isActive = true
    }
    
    func setupTitleLabel() {
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12).isActive = true
        titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12).isActive = true
    }
}
