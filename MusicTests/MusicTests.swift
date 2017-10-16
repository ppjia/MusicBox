//
//  MusicTests.swift
//  MusicTests
//
//  Created by ruixue on 12/10/17.
//  Copyright © 2017 rui. All rights reserved.
//

import XCTest
@testable import Music

class MusicTests: XCTestCase {
    
    func testMusicDataFetching() {
        let session = MockSession()
        session.dataTaskWithRequestCalled = { request in
            (self.loadSampleFileData(fileName: "testjson"), URLResponse(), nil)
        }
        let client = MusicClient(session: session)
        client.fetchMusicDataWith(artistName: "", numberOfItem: 50) { result in
            switch result {
            case let .success(musicDataList):
                XCTAssert(musicDataList.count == 50)
            default:
                XCTFail()
            }
        }
    }
    
    func loadSampleFileData(fileName: String) -> Data? {
        guard let sampleFilePath = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: sampleFilePath)
    }
    
}
