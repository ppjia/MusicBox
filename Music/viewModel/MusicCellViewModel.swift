//
//  MusicCellViewModel.swift
//  Music
//
//  Created by ruixue on 13/10/17.
//  Copyright © 2017 rui. All rights reserved.
//

import UIKit

class MusicCellViewModel: ThumbnailCellViewModelType {
    private let song: MusicData
    
    var isPlaying = false
    
    var thumbnailImageURL: URL? {
        return song.thumbnailUrl
    }
    
    var songName: String {
        return song.trackName
    }
    
    var artistName: String {
        return song.artistName
    }
    
    var albumName: String {
        return song.collectionName
    }
    
    init(song: MusicData) {
        self.song = song
    }
}

