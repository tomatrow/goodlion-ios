//
//  Podcast.swift
//  GoodLion
//
//  Created by AJ Caldwell on 3/7/19.
//  Copyright © 2019 Hesed Creative. All rights reserved.
//

import FeedKit
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
    var duration: Double
}

struct Podcast {
    var episodes: [Episode]
    var title: String
    var description: String
    var cover: URL
}

extension Podcast {
    init(rssFeed: RSSFeed) {
        title = rssFeed.title!
        description = rssFeed.description ?? "<description>"
        let podcastCoverString = rssFeed.image?.url ?? rssFeed.iTunes!.iTunesImage!.attributes!.href!
        let podcastCoverUrl = URL(string: podcastCoverString)!
        cover = podcastCoverUrl
        episodes = rssFeed.items!.map { item -> Episode in
            let att = item.enclosure!.attributes!
            let episodeCoverString = item.iTunes?.iTunesImage?.attributes?.href ?? podcastCoverString
            let media = Media(url: URL(string: att.url!)!, length: att.length!, type: att.type!)
            return Episode(media: media,
                           episodeDescription: item.description!,
                           title: item.title!,
                           cover:  URL(string: episodeCoverString)!, // ??
                           duration: item.iTunes!.iTunesDuration!)
        }
    }
}
