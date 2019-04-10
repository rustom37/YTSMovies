//
//  ViewController.swift
//  YTSMovies
//
//  Created by Steve Rustom on 2/26/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let moviesURL = "https://yts.am/api/v2/list_movies.json"
    var moviesArray : [Movie] = [Movie]()
    let request = GetRequest()
    var disposable : Disposable?
    let movieLogger = MovieLogger()
    var property: MutableProperty<[Movie]>?
    var actionUI : Action<String, [Movie], NoError>?
    var actionLogger : Action<String, [String], NoError>?
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    var titleToPass: String?
    var descriptionToPass: String?
    var posterToPass: UIImage?
    var ratingToPass: Double?

    var spUI: SignalProducer<[Movie], NoError>?
    var spLogger: SignalProducer<[String], NoError>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshClicked))
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        actionUI = Action<String, [Movie], NoError> { (url) -> SignalProducer<[Movie], NoError> in
            self.request.getMoviesData(url: url, forceRefresh: true)
        }
        
        actionLogger = Action<String, [String], NoError> { (url) -> SignalProducer<[String], NoError> in
            self.request.getMovieTitles(url: url, forceRefresh: false)
        }
        
        actionUI?.values.observeValues({ (array) in
            self.moviesArray = array
            self.configureTableView()
            self.moviesTableView.reloadData()
        })
        
        actionUI?.completed.observeValues({
            print("Action UI completed.")
        })
        
        actionLogger?.values.observeValues({ (array) in
           self.movieLogger.displayTitles(array: array)
        })
        
        actionLogger?.completed.observeValues({
            print("Action Logger completed.")
        })
        
        actionUI!.apply(moviesURL).start()
        actionLogger!.apply(moviesURL).start()
        
        moviesTableView.register(UINib(nibName: "CustomMovieTableViewCell", bundle: nil),  forCellReuseIdentifier: "customMovieTableViewCell")
        
        configureTableView()
    }

    @objc func refreshClicked() {
        print("Refresh Button Clicked!")
        self.actionUI!.apply(self.moviesURL).start()
        self.actionLogger!.apply(self.moviesURL).start()
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

        var vc: MovieViewController = self.storyboard?.instantiateViewController(withIdentifier: "MovieViewController") as! MovieViewController
        vc.movieTitlePicked = titleToPass!
        vc.movieDescriptionPicked = descriptionToPass!
        vc.movieRatingPicked = ratingToPass!
        vc.moviePoster = posterToPass!
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func creatorPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToCreator", sender: self)
    }
        
    func configureTableView() {
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.estimatedRowHeight = 150.0
    }
}
