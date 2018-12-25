//
//  SongResult.swift
//  iTunesSearchExample
//
//  Created by LinChe-Ching on 2018/12/22.
//  Copyright © 2018 Che-ching Lin. All rights reserved.
//

import Foundation

struct SongResults: Codable {
    struct Song: Codable {
        var artistName: String
        var trackName: String
        var collectionName: String?
        var previewUrl: URL
        var artworkUrl100: URL
        var trackPrice: Double?
        var releaseDate: Date
        var isStreamable: Bool?
    }
    var resultCount: Int
    var results: [Song]
}
