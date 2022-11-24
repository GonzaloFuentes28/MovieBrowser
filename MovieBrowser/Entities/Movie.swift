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
    let vote_average: Double?
    let title: String?
    let runtime: Int?
    let release_date: String?
    
    func getYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        
        let calendar = Calendar.current
        
        return String(calendar.component(.year, from: formatter.date(from: release_date!)!))
    }
}
