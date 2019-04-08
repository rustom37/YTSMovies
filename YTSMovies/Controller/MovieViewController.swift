//
//  movieViewController.swift
//  YTSMovies
//
//  Created by Steve Rustom on 3/29/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    var movieTitlePicked : String?
    var movieRatingPicked : Double = 0.0
    var movieDescriptionPicked : String?
    var moviePoster : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        movieTitle.text = movieTitlePicked
        movieTitle.adjustsFontSizeToFitWidth = true
        movieRating.text = "Rating: \(movieRatingPicked)"
        movieRating.adjustsFontSizeToFitWidth = true
        movieDescription.text = movieDescriptionPicked
        movieDescription.adjustsFontSizeToFitWidth = true
        poster.image = moviePoster
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        downSwipe.direction = .down
        
        view.addGestureRecognizer(downSwipe)
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            print("Swipe down")
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
