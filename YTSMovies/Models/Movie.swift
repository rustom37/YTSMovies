//
//  Movie.swift
//  YTSMovies
//
//  Created by Steve Rustom on 2/26/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//
import UIKit
import ObjectMapper

class Movie: Mappable {
    
    var title : String?
    var poster : URL?
    var summary : String?
    var dateUploadedUnix : Int?
    var slug : String?
    var imdbCode : String?
    var dateUploaded : Date?
    var rating : Double?
    var synopsis : String?
    var language : String?
    var id : Int?
    var runtime: Int?
    var year : Int?
    var state : String?
    var genres : [String]?
    var description : String?
    var backgroundImageOriginal : URL?
    var backgroundImage : URL?
    var largeCoverImage : URL?
    var mediumCoverImage : URL?
    var url : URL?
    var titleLong : String?
    var titleEnglish : String?
    var torrentsArray : [Torrent]?
    
    required init?(map: Map) {
        
    }
    
    static func urlConverter(txt: String) -> URL {

        guard let url = URL(string: txt) else {
            fatalError("Couldn't convert to URL.")
        }

        return url
    }
    
    func mapping(map: Map) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
        var date = ""
        var txt = ""
        var arr = [String]()
        var txt1 = ""
        var txt2 = ""
        var txt3 = ""
        var txt4 = ""
        var txt5 = ""
        
        date <- map["date_uploaded"]
        guard let movieDate = dateFormatter.date(from: date) else {
                fatalError("Couldn't convert to Date.")
        }
        dateUploaded = movieDate
        title <- map["title"]
        txt <- map["small_cover_image"]
        poster = Movie.urlConverter(txt: txt)
        summary <- map["summary"]
        dateUploadedUnix <- map["date_uploaded_unix"]
        slug <- map["slug"]
        imdbCode <- map["imdb_code"]
        rating <- map["rating"]
        synopsis <- map["synopsis"]
        language <- map["language"]
        id <- map["id"]
        runtime <- map["runtime"]
        year <- map["year"]
        state <- map["state"]
        var movieGenres = [String]()
        arr <- map["genres"]
        for genre in arr {
            movieGenres.append(genre)
        }
        genres = movieGenres
        description <- map["description_full"]
        txt1 <- map["background_image_original"]
        backgroundImageOriginal = Movie.urlConverter(txt: txt1)
        txt2 <- map["background_image"]
        backgroundImage = Movie.urlConverter(txt: txt2)
        txt3 <- map["large_cover_image"]
        largeCoverImage = Movie.urlConverter(txt: txt3)
        txt4 <- map["medium_cover_image"]
        mediumCoverImage = Movie.urlConverter(txt: txt4)
        txt5 <- map["url"]
        url = Movie.urlConverter(txt: txt5)
        titleLong <- map["title_long"]
        titleEnglish <- map["title_english"]
        torrentsArray <- map["torrents"]
    }
}
