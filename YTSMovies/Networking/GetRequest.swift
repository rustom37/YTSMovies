//
//  GetRequest.swift
//  YTSMovies
//
//  Created by Steve Rustom on 3/8/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ReactiveSwift
import Result

class GetRequest {
    
    //MARK: - Networking
    
    var disposable: Disposable?
    
    private var signalProducerMoviesData: SignalProducer<[Movie], NoError>?
    
    func getMoviesData(url: String, forceRefresh: Bool) -> SignalProducer<[Movie], NoError> {
        if let signalProducerMoviesData = signalProducerMoviesData, !forceRefresh {
            return signalProducerMoviesData
        } else {
            let sp = SignalProducer<[Movie], NoError> { observer, Lifetime in
                Alamofire.request(url).responseArray(keyPath: "data.movies") { (response: DataResponse<[Movie]>) in
                    if response.result.isSuccess {
                        print("Success! Got the movies data.")
                        guard let movies = response.result.value else {
                            fatalError("Couldn't receive the list of movies.")
                        }
                        
                        observer.send(value: movies)
                        observer.sendCompleted()
                    } else {
                        print("Error: \(String(describing: response.result.error))")
                    }
                }
            }.replayLazily(upTo: 1)
            signalProducerMoviesData = sp
            return sp
        }
    }
    
    func getMovieTitles(url: String) -> SignalProducer<[String], NoError> {
        let sp = self.getMoviesData(url: url, forceRefresh: true).flatMap(.latest) { (array) -> SignalProducer<[String], NoError> in
            return SignalProducer<[String], NoError> { observer, Lifetime in
                observer.send(value: array.compactMap { $0.title })
                observer.sendCompleted()
            }
        }
        return sp
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
