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
    
    func makeNetworkRequest(requestURL: String, moviesTableView: UITableView, moviesArray: [Movie]) {
        
        var varArray = moviesArray
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
        
        getMoviesData(url: requestURL) { array in
            
            DispatchQueue.main.async {
                
                for movie in array.arrayValue {
                    varArray.append(Movie(movie: movie, dateFormatter: dateFormatter))
                }
//                configureTableView()
                moviesTableView.reloadData()
            }
            
        }
        
    }
    
    
    func getMoviesData(url: String, completionHandler: @escaping ((JSON) -> Void)) {
        
        Alamofire.request(url, method: .get).responseJSON {
            
            response in
            if response.result.isSuccess {
                
                print("Success! Got the movies data")
                let moviesJSON : JSON = JSON(response.result.value!)
                
                let dataArray = moviesJSON["data"]["movies"]
                
                completionHandler(dataArray)
                
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
    }
    
    //MARK: - Loading Images Asynchronously
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, cell: CustomMovieTableViewCell, tableView: UITableView, index: IndexPath) {
        
        tableView.cellForRow(at: index)!.imageView?.image = nil
        
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            
            DispatchQueue.main.async() {
                
                if tableView.cellForRow(at: index) != nil  {
                    tableView.cellForRow(at: index)!.imageView?.image = UIImage(data: data)
                }
            }
        }
    }
    
}
