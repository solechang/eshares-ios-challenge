//
//  TrackDetailsViewController.swift
//  eSharesChallenge
//
//  Created by Chang Choi on 1/3/17.
//  Copyright © 2017 solechang. All rights reserved.
//

import UIKit

class TrackDetailsViewController: UIViewController {
    
    @IBOutlet weak var trackImageView: UIImageView!
    
    @IBOutlet weak var spotifyButton: UIButton!
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    var selectedTrack: Track? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
        
    }
    
    func setUpView() {
        // Set up View
        self.songNameLabel.text = self.selectedTrack?.trackName
        self.artistNameLabel.text = self.selectedTrack?.artistName
        
        self.spotifyButton.layer.cornerRadius = 10
        
        
        if let checkedUrl = URL(string: (self.selectedTrack?.imgLarge)!) {
            self.trackImageView.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl, trackImageView: self.trackImageView)
        }
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL, trackImageView: UIImageView)  {
        
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            
            // Async load images
            DispatchQueue.main.async() { () -> Void in
                trackImageView.image = UIImage(data: data)
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func spotifyButtonPressed(_ sender: AnyObject) {

//        let url = "spotify://\((self.selectedTrack?.uri)!)"
//                print("4.) ", url)
        UIApplication.shared.open(URL(string: (self.selectedTrack?.externalURL)! )!, options: [:], completionHandler: nil)
        
    }

    
}
