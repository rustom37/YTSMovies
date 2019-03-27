//
//  Torrent.swift
//  YTSMovies
//
//  Created by Steve Rustom on 3/7/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import UIKit
import ObjectMapper

class Torrent: Mappable {
    
    var seeds : Int?
    var size : String?
    var sizeBytes : Int?
    var quality : String?
    var torrentDateUploaded : Date?
    var torrentUrl : URL?
    var torrentDateUploadedUnix : Int?
    var peers : Int?
    var hash : String?
    var type : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        var txt = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
        var date = ""
        
        seeds <- map["seeds"]
        size <- map["size"]
        sizeBytes <- map["size_bytes"]
        quality <- map["quality"]
        date <- map["date_uploaded"]
        guard let torrentDate = dateFormatter.date(from: date) else {
            fatalError("Couldn't convert to Date.")
        }
        torrentDateUploaded = torrentDate
        txt <- map["url"]
        torrentUrl = Movie.urlConverter(txt: txt)
        torrentDateUploadedUnix <- map["date_uploaded_unix"]
        peers <- map["peers"]
        hash <- map["hash"]
        type <- map["type"]
        
    }
    
}
