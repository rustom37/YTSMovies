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
                guard let movies = response.result.value else {
                    fatalError("Couldn't receive the list of movies.")
                }
                
                completionHandler(movies)
                
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
    }
    
    //MARK: - Loading Images Asynchronously
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, index: IndexPath, array: [Movie], tableView: UITableView) {
        
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            
            DispatchQueue.main.async() {
                let posterURL = array[index.row].poster
                if let currentCell = tableView.cellForRow(at: index) as? CustomMovieTableViewCell, posterURL == url {
                    currentCell.moviePoster.image = UIImage(data: data)
                }
            }
        }
    }
    
}
