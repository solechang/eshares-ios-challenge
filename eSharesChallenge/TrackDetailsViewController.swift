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
        
        // Spotify Button to match UI
        self.spotifyButton.layer.cornerRadius = 10
        
        // Load Image
        if let checkedUrl = URL(string: (self.selectedTrack?.imgLarge)!) {
            self.trackImageView.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl, trackImageView: self.trackImageView)
        }
        
        // Navigationbar text color
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationController?.navigationBar.tintColor = UIColor.white
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
        //let url = "spotify://\((self.selectedTrack?.uri)!)"

        // Cannot open spotify app because app is not installed through simulator
        // However web is opened with external link
        // I can open Spotify app with "spotify://\((self.selectedTrack?.uri)!)" if Spotify was installed
        UIApplication.shared.open(URL(string: (self.selectedTrack?.externalURL)! )!, options: [:], completionHandler: nil)
        
    }

    
}
