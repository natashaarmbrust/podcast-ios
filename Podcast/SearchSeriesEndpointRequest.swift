//
//  SearchSeriesEndpointRequest.swift
//  Podcast
//
//  Created by Kevin Greer on 3/18/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchSeriesEndpointRequest: EndpointRequest {
    
    init(query: String, offset: Int, max: Int) {
        super.init()
        
        path = "/search/series/\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? query)"
        
        httpMethod = .get
        
        queryParameters = ["offset": offset, "max": max]
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["series"].map{ episodeJson in Series(json: episodeJson.1) }
    }
}

