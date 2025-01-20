//
//  Int+Extension.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import Foundation

extension Int {
    func formatRuntime() -> String {
        let minutes = self
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        var formattedString = ""
        
        if hours > 0 {
            formattedString += "\(hours)h"
        }
        
        if remainingMinutes > 0 {
            if !formattedString.isEmpty {
                formattedString += " "
            }
            formattedString += "\(remainingMinutes)m"
        }
        
        return formattedString.isEmpty ? "0m" : formattedString
    }

}
