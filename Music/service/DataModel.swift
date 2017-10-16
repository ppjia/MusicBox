//
//  DataModel.swift
//  Music
//
//  Created by ruixue on 12/10/17.
//  Copyright © 2017 rui. All rights reserved.
//

import Foundation

struct MusicData {
    let artistID: Int
    let collectionID: Int
    let trackID: Int
    let trackName: String
    let artistName: String
    let collectionName: String
    let previewUrl: URL
    let thumbnailUrl: URL
    
    init?(dictionary: [String: Any]) {
        guard let artistID = dictionary["artistId"] as? Int,
            let collectionID = dictionary["collectionId"] as? Int,
            let trackID = dictionary["trackId"] as? Int,
            let trackName = dictionary["trackName"] as? String,
            let artistName = dictionary["artistName"] as? String,
            let collectionName = dictionary["collectionName"] as? String,
            let previewUrlString = dictionary["previewUrl"] as? String,
            let previewUrl = URL(string: previewUrlString),
            let thumbnailUrlString = dictionary["artworkUrl100"] as? String,
            let thumbnailUrl = URL(string: thumbnailUrlString) else { return nil }
        self.artistID = artistID
        self.collectionID = collectionID
        self.trackID = trackID
        self.trackName = trackName
        self.artistName = artistName
        self.collectionName = collectionName
        self.previewUrl = previewUrl
        self.thumbnailUrl = thumbnailUrl
    }
}
