//
//  CreatorViewController.swift
//  YTSMovies
//
//  Created by Steve Rustom on 3/29/19.
//  Copyright © 2019 Steve Rustom. All rights reserved.
//

import UIKit

class CreatorViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        
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
