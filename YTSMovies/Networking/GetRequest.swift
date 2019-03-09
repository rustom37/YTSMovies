//
//  GetRequest.swift
//  YTSMovies
//
//  Created by Steve Rustom on 3/8/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GetRequest {
    
    //MARK: - Networking
    
    func getMoviesData(url: String, completionHandler: @escaping (([Movie]) -> Void)) {
        
        var moviesArray = [Movie]()
        
        Alamofire.request(url, method: .get).responseJSON {
            
            response in
            if response.result.isSuccess {
                
                print("Success! Got the movies data")
                let moviesJSON : JSON = JSON(response.result.value!)
                
                let dataArray = moviesJSON["data"]["movies"]
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
                
                for movie in dataArray.arrayValue {
                    moviesArray.append(Movie(movie: movie, dateFormatter: dateFormatter))
                }
                
                completionHandler(moviesArray)
                
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
    }
    
}
