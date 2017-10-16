//
//  ThumbnailCellViewModelType.swift
//  Music
//
//  Created by ruixue on 13/10/17.
//  Copyright © 2017 rui. All rights reserved.
//

import UIKit

/// For viewModel with thumbnail fetching
protocol ThumbnailCellViewModelType {
    var thumbnailImageURL: URL? { get }
    
    func loadThumbnail(completionHandler: @escaping (Result<(URL, UIImage), MusicError>) -> Void)
}

/// default implementation for thumbnail loading
extension ThumbnailCellViewModelType {
    func loadThumbnail(completionHandler: @escaping (Result<(URL, UIImage), MusicError>) -> Void) {
        guard let url = thumbnailImageURL else {
            completionHandler(.failure(.unknown))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                error == nil,
                let image = UIImage(data: data) else { return }
            completionHandler(.success((url, image)))
            }.resume()
    }
}
