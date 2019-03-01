//
//  Movie.swift
//  YTSMovies
//
//  Created by Steve Rustom on 2/26/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

class Movie {
    
    var title : String = ""
    var poster : String = ""
    
//    init(title: String, poster: String) {
//        self.title = title
//        self.poster = poster
//    }
    
    init(title: String) {
        self.title = title
    }
    
    func setPoster(poster: String) {
        self.poster = poster
    }
    
}
