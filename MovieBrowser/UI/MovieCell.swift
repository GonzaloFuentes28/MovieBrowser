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
    var yearLabel = UILabel()
    var descriptionTextView = UITextView()
    var cellFooterContainer = UIView()
    var clockImageView = UIImageView(image: UIImage(named: "Clock"))
    var starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
    var durationLabel = UILabel()
    var ratingLabel = UILabel()
    
    var container = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(container)
        container.addSubview(posterImageView)
        container.addSubview(titleLabel)
        container.addSubview(yearLabel)
        container.addSubview(cellFooterContainer)
        
        cellFooterContainer.addSubview(clockImageView)
        cellFooterContainer.addSubview(durationLabel)
        
        cellFooterContainer.addSubview(starImageView)
        cellFooterContainer.addSubview(ratingLabel)
        
        container.addSubview(descriptionTextView)

        clipsToBounds = false
        contentView.clipsToBounds = false
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        setupContainer()
        setupImageView()
        setupTitleLabel()
        setupYearLabel()
        setupCellFooterContainer()
        setupDescriptionTextView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup container
    func setupContainer(){
        container.layer.cornerRadius = 16
        container.layer.masksToBounds = false
        container.layer.shadowRadius = 24
        container.layer.shadowOpacity = 0.1
        container.layer.shadowColor = UIColor(named: "cardShadow")?.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 24)
        
        container.backgroundColor = UIColor(named: "cardBackground")
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        container.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    // MARK: Setup poster
    func setupImageView() {
        posterImageView.layer.cornerRadius = 16
        posterImageView.clipsToBounds = true
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 118/168).isActive = true
    }
    
    // MARK: Setup title
    func setupTitleLabel() {
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor(named: "mainText")
        titleLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor).isActive = true
    }
    
    // MARK: Setup year label
    func setupYearLabel() {
        yearLabel.numberOfLines = 2
        yearLabel.font = UIFont.boldSystemFont(ofSize: 11)
        yearLabel.textColor = UIColor(named: "secondaryText")
        yearLabel.adjustsFontSizeToFitWidth = true
        
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 15).isActive = true
        yearLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15).isActive = true
        yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    // MARK: Setup description
    func setupDescriptionTextView() {
        descriptionTextView.font = UIFont.systemFont(ofSize: 11)
        descriptionTextView.textColor = UIColor(named: "mainText")
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineBreakMode = .byTruncatingTail
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.backgroundColor = .clear

        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 15).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 5).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: cellFooterContainer.topAnchor, constant: -5).isActive = true
    }
    
    // MARK: Setup length container
    func setupCellFooterContainer() {
        cellFooterContainer.translatesAutoresizingMaskIntoConstraints = false
        cellFooterContainer.heightAnchor.constraint(equalToConstant: 16).isActive = true
        cellFooterContainer.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 15).isActive = true
        cellFooterContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15).isActive = true
        cellFooterContainer.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor).isActive = true
        
        setupDuration()
        setupRating()
    }
    
    func setupDuration(){
        clockImageView.translatesAutoresizingMaskIntoConstraints = false
        clockImageView.bottomAnchor.constraint(equalTo: cellFooterContainer.bottomAnchor).isActive = true
        clockImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        clockImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        clockImageView.leadingAnchor.constraint(equalTo: cellFooterContainer.leadingAnchor).isActive = true
        
        durationLabel.font = UIFont.systemFont(ofSize: 11)
        durationLabel.textColor = UIColor(named: "secondaryText")
        durationLabel.adjustsFontSizeToFitWidth = true
        
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.leadingAnchor.constraint(equalTo: clockImageView.trailingAnchor, constant: 8).isActive = true
        durationLabel.centerYAnchor.constraint(equalTo: clockImageView.centerYAnchor).isActive = true
    }
    
    func setupRating(){
        ratingLabel.font = UIFont.systemFont(ofSize: 11)
        ratingLabel.textColor = UIColor(named: "secondaryText")
        ratingLabel.adjustsFontSizeToFitWidth = true
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.trailingAnchor.constraint(equalTo: cellFooterContainer.trailingAnchor, constant: -15).isActive = true
        ratingLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor).isActive = true
        
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.bottomAnchor.constraint(equalTo: cellFooterContainer.bottomAnchor).isActive = true
        starImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        starImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        starImageView.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -8).isActive = true
        starImageView.tintColor = UIColor(named: "secondaryText")
    }
}
