//
//  APIClient.swift
//  Music
//
//  Created by ruixue on 12/10/17.
//  Copyright © 2017 rui. All rights reserved.
//

import Foundation

enum MusicError: Error {
    case network(Error)
    case malformedEndpoint
    case deserializing
    case unknown
}

enum Result<T, Error> {
    case success(T)
    case failure(Error)
}

struct MusicClient {
    private let endpoint = "https://itunes.apple.com/search"
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchMusicDataWith(artistName: String,
                            numberOfItem: Int,
                            completionHandler: @escaping (Result<[MusicData], MusicError>) -> Void) {
        let encodedArtistName = artistName.components(separatedBy: " ").joined(separator: "+")
        fetchMusicData(with: ["term": encodedArtistName, "limit": "\(numberOfItem)"], completionHandler: completionHandler)
    }
    
    private func fetchMusicData(with requestParameters: [String: String],
                                completionHandler: @escaping (Result<[MusicData], MusicError>) -> Void) {
        guard let request = urlRequestWith(requestParameters: requestParameters) else {
            completionHandler(.failure(.malformedEndpoint))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error { return completionHandler(.failure(.network(error))) }
            guard let data = data,
                let jsonData = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                let resultsData = jsonData["results"] as? [[String: Any]] else {
                    return completionHandler(.failure(.deserializing))
            }
            let musicDataList = resultsData.flatMap { MusicData(dictionary: $0) }.flatMap { $0 }
            completionHandler(.success(musicDataList))
            }.resume()
    }
    
    private func urlRequestWith(requestParameters: [String: String]) -> URLRequest? {
        guard let url = URL(string: endpoint),
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
        urlComponents.queryItems = requestParameters.map { URLQueryItem(name: $0.0, value: $0.1) }
        guard let urlCompleted = urlComponents.url else { return nil }
        return URLRequest(url: urlCompleted)
    }
}
