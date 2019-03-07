//
//  Torrent.swift
//  YTSMovies
//
//  Created by Steve Rustom on 3/7/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import UIKit

struct Torrent {
    
    var seeds : Int = 0
    var size : String = ""
    var sizeBytes : Int = 0
    var quality : String = ""
    var dateUploaded : Date = Date()
    var url : URL
    var dateUploadedUnix : Int = 0
    var peers : Int
    var hash : String = ""
    var type : String = ""
    
    init(seeds: Int, size: String, sizeBytes : Int, quality : String, dateUploaded : Date, url : URL, dateUploadedUnix : Int, peers : Int, hash : String, type : String) {
        
        self.seeds = seeds
        self.size = size
        self.sizeBytes = sizeBytes
        self.quality = quality
        self.dateUploaded = dateUploaded
        self.url = url
        self.dateUploadedUnix = dateUploadedUnix
        self.peers = peers
        self.hash = hash
        self.type = type
        
    }
    
}
