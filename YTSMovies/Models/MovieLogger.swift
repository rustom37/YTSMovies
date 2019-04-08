//
//  MovieLogger.swift
//  YTSMovies
//
//  Created by Steve Rustom on 4/8/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import Foundation

class MovieLogger {
    
    func displayTitles(array : [String]) {
        print("/////////////////////////////////////////////")
        print("THE LIST OF MOVIES FROM THE MOVIE LOGGER IS:")
        for movie in array {
            print("\(movie)\n")
        }
        print("/////////////////////////////////////////////")
    }
}
