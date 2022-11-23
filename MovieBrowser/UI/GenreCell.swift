//
//  GenderCell.swift
//  MovieBrowser
//
//  Created by Gonzalo Fuentes on 23/11/22.
//

import Foundation
import UIKit

class GenreCell: UITableViewCell {
    var genreLabel = UILabel()
    
    var container = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(container)
        container.addSubview(genreLabel)
        

        clipsToBounds = false
        contentView.clipsToBounds = false
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        setupContainer()
        setupTitleLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup container
    func setupContainer(){
        container.layer.cornerRadius = 8
        container.layer.masksToBounds = false
        container.layer.shadowRadius = 5
        container.layer.shadowOpacity = 0.1
        container.layer.shadowColor = UIColor(named: "cardShadow")?.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        container.backgroundColor = UIColor(named: "cardBackground")
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        container.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
    
    // MARK: Setup title
    func setupTitleLabel() {
        genreLabel.numberOfLines = 0
        genreLabel.font = UIFont.boldSystemFont(ofSize: 16)
        genreLabel.textColor = UIColor(named: "mainText")
        genreLabel.adjustsFontSizeToFitWidth = true
        
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        genreLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
    }
}
