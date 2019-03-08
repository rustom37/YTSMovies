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
    let request = GetRequest()
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        request.makeNetworkRequest(requestURL: moviesURL, moviesTableView: moviesTableView, moviesArray: moviesArray)
        
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
        
        request.downloadImage(from: moviesArray[indexPath.row].poster, cell: cell, tableView: tableView, index: indexPath)

        return cell
    }
    
    func configureTableView() {
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.estimatedRowHeight = 150.0
    }
    
//    //MARK: - Networking
//
//    func makeNetworkRequest(requestURL: String) {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
//
//        getMoviesData(url: requestURL) { array in
//
//            DispatchQueue.main.async {
//
//                for movie in array.arrayValue {
//                    self.moviesArray.append(Movie(movie: movie, dateFormatter: dateFormatter))
//                }
//
//                self.configureTableView()
//                self.moviesTableView.reloadData()
//            }
//
//        }
//
//    }
//
//
//    func getMoviesData(url: String, completionHandler: @escaping ((JSON) -> Void)) {
//
//        Alamofire.request(url, method: .get).responseJSON {
//
//            response in
//            if response.result.isSuccess {
//
//                print("Success! Got the movies data")
//                let moviesJSON : JSON = JSON(response.result.value!)
//
//                let dataArray = moviesJSON["data"]["movies"]
//
//                completionHandler(dataArray)
//
//            } else {
//                print("Error: \(String(describing: response.result.error))")
//            }
//        }
//    }
//
//    //MARK: - Loading Images Asynchronously
//
//    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
//    }
//
//    func downloadImage(from url: URL, cell: CustomMovieTableViewCell, tableView: UITableView, index: IndexPath) {
//
//        //tableView.cellForRow(at: index)?.imageView?.image = nil
//
//        print("Download Started")
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//
//            DispatchQueue.main.async() {
//
//                if tableView.cellForRow(at: index) != nil  {
//                    if tableView.cellForRow(at: index)?.imageView?.image == UIImage(data: data) {
//                        tableView.cellForRow(at: index)!.imageView?.image = nil
//                    } else {
//                        tableView.cellForRow(at: index)!.imageView?.image = UIImage(data: data)
//                    }
//                }
//            }
//        }
//    }
}
