//
//  ViewController.swift
//  YTSMovies
//
//  Created by Steve Rustom on 2/26/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let moviesURL = "https://yts.am/api/v2/list_movies.json"
    var moviesArray : [Movie] = [Movie]()
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        makeNetworkRequest(requestURL: moviesURL)
        
        moviesTableView.register(UINib(nibName: "CustomMovieTableViewCell", bundle: nil),  forCellReuseIdentifier: "customMovieTableViewCell")
        
        configureTableView()
        
    }
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMovieTableViewCell", for: indexPath) as! CustomMovieTableViewCell

        cell.movieTitle.text = moviesArray[indexPath.row].title
        cell.movieTitle.adjustsFontSizeToFitWidth = true

        let posterURL = urlConverter(txt: moviesArray[indexPath.row].poster)

        downloadImage(from: posterURL, cell: cell, tableView: tableView, index: indexPath)

        return cell
    }
    
    func configureTableView() {
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.estimatedRowHeight = 150.0
    }
    
    //MARK: - Networking
    
    func makeNetworkRequest(requestURL: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
        
        getMoviesData(url: requestURL) { array in
            
            DispatchQueue.main.async {
                
                for movie in array.arrayValue {
                    let movieTitle = movie["title"].stringValue
                    let moviePoster = movie["small_cover_image"].stringValue
                    let movieSummary = movie["summary"].stringValue
                    let movieDateUploadedUnix = movie["date_uploaded_unix"].intValue
                    let movieSlug = movie["slug"].stringValue
                    let movieImbd = movie["imdb_code"].stringValue
                    
                    guard let movieDate = dateFormatter.date(from: movie["date_uploaded"].stringValue) else {
                        fatalError("Couldn't convert to Date.")
                    }
                    
                    let movieRating = movie["rating"].doubleValue
                    let movieSynopsis = movie["synopsis"].stringValue
                    let movieLanguage = movie["language"].stringValue
                    let movieID = movie["id"].intValue
                    let movieRuntime = movie["runtime"].intValue
                    let movieYear = movie["year"].intValue
                    let movieState = movie["state"].stringValue
                   
                    var movieGenres = [String]()
                    for genre in movie["genres"].arrayValue {
                        movieGenres.append(genre.stringValue)
                    }
                    
                    let movieFullDescription = movie["description_full"].stringValue
                    let movieBackgroundImageOriginal = self.urlConverter(txt: movie["background_image_original"].stringValue)
                    let movieBackgroundImage = self.urlConverter(txt: movie["background_image"].stringValue)
                    let movieLargeCoverImage = self.urlConverter(txt: movie["large_cover_image"].stringValue)
                    let movieMediumCoverImage = self.urlConverter(txt: movie["medium_cover_image"].stringValue)
                    let movieURL = self.urlConverter(txt: movie["url"].stringValue)
                    let movieTitleLong = movie["title_long"].stringValue
                    let movieTitleEnglish = movie["title_english"].stringValue
                    
                    var movieTorrents = [Torrent]()
                    for torrent in movie["torrents"].arrayValue {
                        
                        guard let torrentDate = dateFormatter.date(from: torrent["date_uploaded"].stringValue) else {
                            fatalError("Couldn't convert to Date.")
                        }
                        
                        movieTorrents.append(Torrent(seeds: torrent["seeds"].intValue, size: torrent["size"].stringValue, sizeBytes: torrent["size_bytes"].intValue, quality: torrent["quality"].stringValue, dateUploaded: torrentDate, url: self.urlConverter(txt: torrent["url"].stringValue), dateUploadedUnix: torrent["date_uploaded_unix"].intValue, peers: torrent["peers"].intValue, hash: torrent["hash"].stringValue, type: torrent["type"].stringValue))
                    }
                    
                    self.moviesArray.append(Movie(title: movieTitle, poster: moviePoster, summary: movieSummary, dateUploadedUnix: movieDateUploadedUnix, slug: movieSlug, imdbCode: movieImbd, dateUploaded: movieDate, rating: movieRating, synopsis: movieSynopsis, language: movieLanguage, id: movieID, runtime: movieRuntime, year: movieYear, state: movieState, genres: movieGenres, description: movieFullDescription, backgroundImageOriginal : movieBackgroundImageOriginal, backgroundImage : movieBackgroundImage, largeCoverImage : movieLargeCoverImage, mediumCoverImage : movieMediumCoverImage, url : movieURL, titleLong : movieTitleLong, titleEnglish : movieTitleEnglish, torrentsArray : movieTorrents))
                }
                
                self.configureTableView()
                self.moviesTableView.reloadData()
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
    
    func urlConverter(txt: String) -> URL {
        
        guard let url = URL(string: txt) else {
            fatalError("Couldn't convert to URL.")
        }
        
        return url
    }
    
    //MARK: - Loading Images Asynchronously
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, cell: CustomMovieTableViewCell, tableView: UITableView, index: IndexPath) {
        
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            
            DispatchQueue.main.async() {

                if tableView.cellForRow(at: index) != nil  {
                    
                    cell.moviePoster.image = UIImage(data: data)
                }
            }
        }
    }
}
