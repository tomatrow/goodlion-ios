//
//  FetchController.swift
//  GoodLion
//
//  Created by AJ Caldwell on 4/16/19.
//  Copyright © 2019 Hesed Creative. All rights reserved.
//

import Alamofire
import FeedKit
import Foundation

typealias FetchControllerCompletion = (Podcast?, URL) -> Void

protocol FetchController {
    func load(url: URL, on completion: @escaping FetchControllerCompletion)
}

struct ServerFetchContoller: FetchController {
    func load(url: URL, on completion: @escaping FetchControllerCompletion) {
        SessionManager.default.request(url).responseData { response in

            guard case let .success(podcastData) = response.result else {
                completion(nil, url)
                return
            }
            let parser = FeedParser(data: podcastData)
            guard case let .rss(feed) = parser.parse() else {
                completion(nil, url)
                return
            }

            let podcast = Podcast(feedUrl: url, rssFeed: feed)
            completion(podcast, url)
        }
    }
}

extension Podcast {
    init(feedUrl _: URL, rssFeed: RSSFeed) {
        title = rssFeed.title!
        author = rssFeed.iTunes!.iTunesAuthor!
        description = rssFeed.description ?? rssFeed.iTunes?.iTunesSummary ?? "The \(rssFeed.title!) podcast."
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
                           cover: URL(string: episodeCoverString)!,
                           duration: item.iTunes!.iTunesDuration!,
                           date: item.pubDate!)
        }
    }
}
