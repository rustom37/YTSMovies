//
//  ViewController.swift
//  YTSMovies
//
//  Created by Steve Rustom on 2/26/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let moviesURL = "https://yts.am/api/v2/list_movies.json"
    var moviesArray : [Movie] = [Movie]()
    let request = GetRequest()
    var disposable : Disposable?
    let movieLogger = MovieLogger()
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    var titleToPass: String?
    var descriptionToPass: String?
    var posterToPass: UIImage?
    var ratingToPass: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        let observerUI = Signal<[Movie], NoError>.Observer(value: { (array) in
            self.moviesArray = array
            self.configureTableView()
            self.moviesTableView.reloadData()
        }, failed: { (error) in
            print("UI Observer Error: \(error).")
        }, completed: {
            print("UI Observer Completed.")
        }, interrupted: {
            print("UI Observer Interrupted.")
        })
        
        let observerLogger = Signal<[String], NoError>.Observer(value: { (array) in
           self.movieLogger.displayTitles(array: array)
        }, failed: { (error) in
            print("Logger Observer Error: \(error).")
        }, completed: {
            print("Logger Observer Completed.")
        }, interrupted: {
            print("Logger Observer Interrupted.")
        })
        
        let spUI = request.getMoviesData(url: moviesURL, forceRefresh: false)
        
        let spLogger = request.getMovieTitles(url: moviesURL)
        
        disposable = spUI.start(observerUI)
        disposable = spLogger.start(observerLogger)
        
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
        cell.movieTitle.minimumScaleFactor = 0.25
        cell.moviePoster.image = nil
        request.downloadImage(from: moviesArray[indexPath.row].poster!, index: indexPath, array: moviesArray, tableView: moviesTableView)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        titleToPass = moviesArray[indexPath.row].title
        descriptionToPass = moviesArray[indexPath.row].description
        ratingToPass = moviesArray[indexPath.row].rating
        
        do {
            let data = try Data(contentsOf: moviesArray[indexPath.row].mediumCoverImage!)
            posterToPass = UIImage(data: data)
        } catch {
            fatalError("Couldn't load image.")
        }

        performSegue(withIdentifier: "toMovieDetails", sender: self)
    }
    
    @IBAction func creatorPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToCreator", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toMovieDetails" {
            let nav = segue.destination as! UINavigationController
            let destVC = nav.topViewController as! MovieViewController
            
            destVC.movieTitlePicked = titleToPass!
            destVC.movieDescriptionPicked = descriptionToPass!
            destVC.movieRatingPicked = ratingToPass!
            destVC.moviePoster = posterToPass!
        } 
    }
    
    func configureTableView() {
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.estimatedRowHeight = 150.0
    }
    
}
