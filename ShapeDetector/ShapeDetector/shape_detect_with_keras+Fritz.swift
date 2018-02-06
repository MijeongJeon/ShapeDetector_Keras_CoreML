//
//  shape_detect_with_keras+Fritz.swift
//  ShapeDetector
//
//  Created by Eric Hsiao on 2/6/18.
//  Copyright © 2018 MijeonJeon. All rights reserved.
//

import Fritz

extension shape_detect_with_keras: SwiftIdentifiedModel {
    
    static let modelIdentifier = "<insert model id>"
    
    static let packagedModelVersion = 1
    
    static let session = Session(appToken: "<insert app token>")
}
