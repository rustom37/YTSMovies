//
//  Movie.swift
//  YTSMovies
//
//  Created by Steve Rustom on 2/26/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//
import UIKit

struct Movie {
    
    var title : String = ""
    var poster : String = ""
    var summary : String = ""
    var dateUploadedUnix : Int = 0
    var slug : String = ""
    var imdbCode : String = ""
    var dateUploaded : Date = Date()
    var rating : Double = 0.0
    var synopsis : String = ""
    var language : String = ""
    var id : Int = 0
    var runtime: Int = 0
    var year : Int = 0
    var state : String = ""
    var genres : [String] = [String]()
    var description : String = ""
    var backgroundImageOriginal : URL
    var backgroundImage : URL
    var largeCoverImage : URL
    var mediumCoverImage : URL
    var url : URL
    var titleLong : String = ""
    var titleEnglish : String = ""
    var torrentsArray : [Torrent] = [Torrent]()
    
    
    init(title: String, poster: String, summary : String, dateUploadedUnix : Int, slug : String, imdbCode : String, dateUploaded : Date, rating : Double, synopsis : String, language : String, id : Int, runtime : Int, year : Int, state : String, genres : [String], description : String, backgroundImageOriginal : URL, backgroundImage : URL, largeCoverImage : URL, mediumCoverImage : URL, url : URL, titleLong : String, titleEnglish : String, torrentsArray : [Torrent]) {
        
        self.title = title
        self.poster = poster
        self.summary = summary
        self.dateUploadedUnix = dateUploadedUnix
        self.slug = slug
        self.imdbCode = imdbCode
        self.dateUploaded = dateUploaded
        self.rating = rating
        self.synopsis = synopsis
        self.language = language
        self.id = id
        self.runtime = runtime
        self.year = year
        self.state = state
        self.genres = genres
        self.description = description
        self.backgroundImageOriginal = backgroundImageOriginal
        self.backgroundImage = backgroundImage
        self.largeCoverImage = largeCoverImage
        self.mediumCoverImage = mediumCoverImage
        self.url = url
        self.titleLong = titleLong
        self.titleEnglish = titleEnglish
        self.torrentsArray = torrentsArray
    }
    
}
