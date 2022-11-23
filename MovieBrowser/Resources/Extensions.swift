//
//  Extensions.swift
//  MovieBrowser
//
//  Created by Gonzalo Fuentes on 23/11/22.
//

import Foundation

extension Int {
    func convertToMovieLength() -> String {
        let value = self
        
        if value < 60 {
            return String(value) + "m"
        } else {
            let hours = value / 60
            let minutes = value % 60
            
            return minutes > 0 ? String(hours) + "h " + String(minutes) + "m" : String(hours) + "h"
        }
    }
}
