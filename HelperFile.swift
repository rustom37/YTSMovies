//
//  HelperFile.swift
//  YTSMovies
//
//  Created by Steve Rustom on 3/29/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import Foundation

func urlConverter(txt: String) -> URL {
    
    guard let url = URL(string: txt) else {
        fatalError("Couldn't convert to URL.")
    }
    
    return url
}

func dateConverter(txt: String) -> Date? {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
    
    if txt == "" {
        
        return dateFormatter.defaultDate
        
    } else {
        
        guard let date = dateFormatter.date(from: txt) else {
            fatalError("Couldn't convert to Date.")
        }
        
        return date
    }
}
