//
//  Movie.swift
//  YTSMovies
//
//  Created by Steve Rustom on 2/26/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//
import UIKit

class Movie {
    
    var title : String = ""
//    var poster : String = ""
    var poster = UIImage()
    
    init(title: String, poster: UIImage) {
        self.title = title
        self.poster = poster
    }
    
//    init(title: String) {
//        self.title = title
//    }
//
//    func setPoster(poster: String) {
//        self.poster = poster
//    }
    
}
