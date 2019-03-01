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
        getMoviesData(url: moviesURL)
        
        moviesTableView.register(UINib(nibName: "CustomMovieTableViewCell", bundle: nil),  forCellReuseIdentifier: "customMovieTableViewCell")
        
        configureTableView()

    }
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMovieTableViewCell", for: indexPath) as! CustomMovieTableViewCell
        
        cell.movieTitle.text = moviesArray[indexPath.row].title
        
        guard let posterURL = URL(string: moviesArray[indexPath.row].poster) else {
            fatalError("Couldn't receive the correct URL.")
        }
        
        do {
            let posterData = try Data(contentsOf: posterURL)
            cell.moviePoster.image = UIImage(data: posterData)
        } catch {
            print("Error retrieving the contents of URL, \(error)")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return moviesArray.count
    }
    
    func configureTableView() {
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.estimatedRowHeight = 150.0
    }
    
    //MARK: - Networking
    
    func getMoviesData(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON {
            
            response in
            if response.result.isSuccess {
                
                print("Success! Got the movies data")
                let moviesJSON : JSON = JSON(response.result.value!)
                
                let dataArray = moviesJSON["data"]["movies"]
                
                for movie in dataArray.arrayValue {
                    let movieTitle = movie["title"].stringValue
                    let movieURL = movie["small_cover_image"].stringValue
                    self.moviesArray.append(Movie(title: movieTitle, poster: movieURL))
                }

                self.configureTableView()
                self.moviesTableView.reloadData()
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
    }
}

