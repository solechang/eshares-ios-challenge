//
//  Track.swift
//  eSharesChallenge
//
//  Created by Chang Choi on 1/3/17.
//  Copyright © 2017 solechang. All rights reserved.
//

import UIKit

class Track: NSObject {
    
    var trackName :String = ""
    var artistName :String = ""
    var img :String = "" //thumbnail
    var imgLarge :String = ""
    var externalURL :String = ""
    var uri :String = ""
    
    
    // init
    // Making sure values are not nil. If so, default Track's variables to empty strings
    init(trackName :String?, artistName :String?, img :String?, imgLarge :String?, externalURL :String?, uri :String? ) {
        
        if trackName != nil {
            self.trackName = trackName!
        } else {
            self.trackName = ""
        }
        
        if artistName != nil {
            self.artistName = artistName!
        } else {
            self.artistName = ""
        }
        
        if img != nil {
            self.img = img!
        } else {
            self.img = ""
        }
        
        if imgLarge != nil {
            self.imgLarge = imgLarge!
        } else {
            self.imgLarge = ""
        }
        
        if externalURL != nil {
            self.externalURL = externalURL!
        } else {
            self.externalURL = ""
        }
        
        if uri != nil {
            self.uri = uri!
        } else {
            self.uri = ""
        }
        
        
    }
    

}
