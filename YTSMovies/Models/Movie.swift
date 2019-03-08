//
//  Movie.swift
//  YTSMovies
//
//  Created by Steve Rustom on 2/26/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//
import UIKit
import SwiftyJSON

class Movie {
    
    var title : String = ""
    var poster : URL
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
    
    static func urlConverter(txt: String) -> URL {
        
        guard let url = URL(string: txt) else {
            fatalError("Couldn't convert to URL.")
        }
        
        return url
    }
    
    init(movie: JSON, dateFormatter: DateFormatter) {
        
        guard let movieDate = dateFormatter.date(from: movie["date_uploaded"].stringValue) else {
            fatalError("Couldn't convert to Date.")
        }
        
        title = movie["title"].stringValue
        poster = Movie.urlConverter(txt: movie["small_cover_image"].stringValue)
        summary = movie["summary"].stringValue
        dateUploadedUnix = movie["date_uploaded_unix"].intValue
        slug = movie["slug"].stringValue
        imdbCode = movie["imdb_code"].stringValue
        dateUploaded = movieDate
        rating = movie["rating"].doubleValue
        synopsis = movie["synopsis"].stringValue
        language = movie["language"].stringValue
        id = movie["id"].intValue
        runtime = movie["runtime"].intValue
        year = movie["year"].intValue
        state = movie["state"].stringValue
        
        var movieGenres = [String]()
        for genre in movie["genres"].arrayValue {
            movieGenres.append(genre.stringValue)
        }
        genres = movieGenres
        
        description = movie["description_full"].stringValue
        backgroundImageOriginal = Movie.urlConverter(txt: movie["background_image_original"].stringValue)
        backgroundImage = Movie.urlConverter(txt: movie["background_image"].stringValue)
        largeCoverImage = Movie.urlConverter(txt: movie["large_cover_image"].stringValue)
        mediumCoverImage = Movie.urlConverter(txt: movie["medium_cover_image"].stringValue)
        url = Movie.urlConverter(txt: movie["url"].stringValue)
        titleLong = movie["title_long"].stringValue
        titleEnglish = movie["title_english"].stringValue
        
        var movieTorrents = [Torrent]()
        for torrent in movie["torrents"].arrayValue {
            
            movieTorrents.append(Torrent(torrent: torrent, dateFormatter: dateFormatter))
        }
        torrentsArray = movieTorrents
    }
}
