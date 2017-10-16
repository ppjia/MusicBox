//
//  MusicTableViewModel.swift
//  Music
//
//  Created by ruixue on 13/10/17.
//  Copyright © 2017 rui. All rights reserved.
//

import Foundation

class MusicTableViewModel {
    private let client = MusicClient()
    private var songList: [MusicData] = []
    
    var numberOfSongs: Int {
        return songList.count
    }
    
    func song(at index: Int) -> MusicData? {
         return songList[safe: index]
    }
    
    func fetchSongListWith(artistName: String, limitNumber: Int, completionHandler: @escaping (String?) -> Void) {
        client.fetchMusicDataWith(artistName: artistName, numberOfItem: limitNumber) { [weak self] result in
            guard let sself = self else { return }
            switch result {
            case let .success(songList):
                sself.songList = songList
                completionHandler(nil)
            case .failure(_):
                completionHandler("Error to load song list!")
            }
        }
    }
}
