//
//  NewReleasesTableViewController.swift
//  eSharesChallenge
//
//  Created by Chang Choi on 12/21/16.
//  Copyright © 2016 solechang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewReleasesTableViewController: UITableViewController {
    
    var tracksArray: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getSpotifyAuth()
    }
    
    func getSpotifyAuth() {
        
        
        let clientId = "2749e2f97b65434a86f0054d51f2303b"
        let clientSecret = "0ed59725d79240d3910cfba50d44d545"
        
        let authBase = "\(clientId):\(clientSecret)"
        
        let data = (authBase).data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        
        Alamofire.request("https://accounts.spotify.com/api/token",
                          method: .post,
                          parameters: ["grant_type" : "client_credentials"],
                          encoding: URLEncoding.default,
                          headers: ["Authorization" : "Basic \(base64)"])
            .responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    
                    if let result = response.result.value {
                        let accessToken = result as! NSDictionary
                        
                        self.getNewReleases(accessToken: accessToken["access_token"] as! String)
                    }
                    
                    
                    break
                    
                case .failure(_):
                    print(response.result.error)
                    break
                }
        }
    
    }
    
    func getNewReleases( accessToken :String) {
        
        // initialize tracksArray
        self.tracksArray = []
        
        Alamofire.request("https://api.spotify.com/v1/browse/new-releases",
                          method: .get,
                          parameters: [:],
                          encoding: URLEncoding.default,
                          headers: ["Authorization" : "Bearer \(accessToken)"])
            .responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    
                    if let result = response.result.value {
                        let data = result as! NSDictionary
                        
                        let albums = data["albums"]  as! NSDictionary
                        
                        if let items = albums["items"] as? [[String:Any]] {
                        
                            for item in items {
                                
                                // Extracting track data
                                let track = Track()
                                
                                track.trackName = item["name"] as! String
                                
                                let artists = item["artists"]  as! NSArray
                                
                                // Getting artist data. Seems like the data comes from the first index of the artists array
                                let artist = artists[0] as? NSDictionary
                                track.artistName = artist?["name"] as! String
                                
                                // URI
                                track.uri = artist?["uri"] as! String
                                
                                // External URL
                                let externalURL = artist?["external_urls"] as! NSDictionary
                                
                                track.externalURL =  externalURL["spotify"] as! String
                                
                                let images = item["images"]  as! NSArray
                                
                                // Getting the thumbnail size of the image
                                let image = images[2] as? NSDictionary
                                track.img = image?["url"] as! String
                                
                                let imageLarge = images[0] as? NSDictionary
                                track.imgLarge = imageLarge?["url"] as! String
                                
                                self.tracksArray.append(track)
                                
                                self.tableView.reloadData()
                                
                            }
                       
                        }
                        
                    }
                    
                    break
                    
                case .failure(_):
                    // Errors
                    print("2.0) ", response.result.error)
                    break
                }
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tracksArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TrackTableViewCell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackTableViewCell

        let track = self.tracksArray[indexPath.row]
        
        cell.trackNameLabel.text = track.trackName
        cell.artistNameLabel.text = track.artistName
        
        if let checkedUrl = URL(string: track.img) {
            cell.trackImageView.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl, trackImageView: cell.trackImageView)
        }
        

        return cell
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "trackDetailsSegue", sender: self)
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "trackDetailsSegue" {
            let viewController:TrackDetailsViewController = segue.destination as! TrackDetailsViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            viewController.selectedTrack = self.tracksArray[(indexPath?.row)!]
            
        }
    }
    

}
