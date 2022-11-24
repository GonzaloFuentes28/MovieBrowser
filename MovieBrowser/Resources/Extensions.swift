//
//  Extensions.swift
//  MovieBrowser
//
//  Created by Gonzalo Fuentes on 23/11/22.
//

import Foundation
import UIKit

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

extension UITableView {
    func indexPathExists(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }

    func scrollToTop(animated: Bool) {
        let indexPath = IndexPath(row: 0, section: 0)
        
        if self.indexPathExists(indexPath: indexPath) {
            self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}
