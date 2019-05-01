//
//  Podcast.swift
//  GoodLion
//
//  Created by AJ Caldwell on 3/7/19.
//  Copyright © 2019 Hesed Creative. All rights reserved.
//

import Foundation

struct Media {
    var url: URL
    var length: Int64
    var type: String
}

struct Episode {
    var media: Media
    var episodeDescription: String
    var title: String
    var cover: URL
    var duration: TimeInterval
    var date: Date
}

struct Podcast {
    var episodes: [Episode]
    var title: String
    var description: String
    var cover: URL
    var author: String
}
