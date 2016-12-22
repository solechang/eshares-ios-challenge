//
//  AuthorizeSpotifyRequest.swift
//  eSharesChallenge
//
//  Created by Chang Choi on 12/21/16.
//  Copyright © 2016 solechang. All rights reserved.
//

import UIKit
import Alamofire

class AuthorizeSpotifyRequestBaseRequest: SpotifyBaseRequest {
    
    override func path() -> String {
        return "\(apiEndpointURL)/authorize/"
        //?client_id=2749e2f97b65434a86f0054d51f2303b&response_type=code&redirect_uri=eshareschallenge://callback&scope=user-read-private%20user-read-email&state=34fFs29kd09s
    }
    
    override func method() -> HTTPMethod {
        return HTTPMethod.get
    }
    
    override func params() -> [String: AnyObject]? {
        
       
        
        return params()
    }
    
}
