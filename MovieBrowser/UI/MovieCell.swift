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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(posterImageView)
        addSubview(titleLabel)
        
        setupImageView()
        setupTitleLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView() {
        posterImageView.layer.cornerRadius = 10
        posterImageView.clipsToBounds = true
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 9/16).isActive = true
    }
    
    func setupTitleLabel() {
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
    }
}
