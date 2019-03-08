//
//  Torrent.swift
//  YTSMovies
//
//  Created by Steve Rustom on 3/7/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import UIKit
import SwiftyJSON

class Torrent {
    
    var seeds : Int = 0
    var size : String = ""
    var sizeBytes : Int = 0
    var quality : String = ""
    var torrentDateUploaded : Date = Date()
    var torrentUrl : URL
    var torrentDateUploadedUnix : Int = 0
    var peers : Int
    var hash : String = ""
    var type : String = ""
    
    init(torrent: JSON, dateFormatter: DateFormatter) {
        
        guard let torrentDate = dateFormatter.date(from: torrent["date_uploaded"].stringValue) else {
                fatalError("Couldn't convert to Date.")
        }
        
        seeds = torrent["seeds"].intValue
        size = torrent["size"].stringValue
        sizeBytes = torrent["size_bytes"].intValue
        quality = torrent["quality"].stringValue
        torrentDateUploaded = torrentDate
        torrentUrl = Movie.urlConverter(txt: torrent["url"].stringValue)
        torrentDateUploadedUnix = torrent["date_uploaded_unix"].intValue
        peers = torrent["peers"].intValue
        hash = torrent["hash"].stringValue
        type = torrent["type"].stringValue
    }
    
}
