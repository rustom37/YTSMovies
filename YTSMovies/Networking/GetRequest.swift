//
//  GetRequest.swift
//  YTSMovies
//
//  Created by Steve Rustom on 3/8/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class GetRequest {
    
    //MARK: - Networking
    
    func getMoviesData(url: String, completionHandler: @escaping (([Movie]) -> Void)) {
        
        Alamofire.request(url).responseArray(keyPath: "data.movies") { (response: DataResponse<[Movie]>) in
            
            if response.result.isSuccess {
                
                print("Success! Got the movies data")
                let movies = response.result.value
                
                completionHandler(movies!)
                
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
    }
    
}
