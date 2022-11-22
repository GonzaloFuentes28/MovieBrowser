//
//  Movie.swift
//  MovieBrowser
//
//  Created by Gonzalo Fuentes on 22/11/22.
//

import Foundation

struct Movie: Codable {
    let id: Int?
    let poster_path: String?
    let overview: String?
    let release_date: String?
    let original_title: String?
    let original_language: String?
    let title: String?
}
