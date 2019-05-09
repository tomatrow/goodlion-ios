//
//  NetworkController.swift
//  GoodLion
//
//  Created by AJ Caldwell on 4/10/19.
//  Copyright © 2019 Hesed Creative. All rights reserved.
//

import Foundation

protocol NetworkControllerDelegate: AnyObject {
    func didLoad(podcast: Podcast)
    func finishedLoading()
}

class NetworkController {
    weak var delegate: NetworkControllerDelegate?
    var network = [Podcast]()
    let fetcher: FetchController = ServerFetchContoller()
}

extension NetworkController {
    // load podcasts from network
    func load() {
        let info: [String] = [
            "http://beyondreadingthebible.com/feed/podcast", // beyondreadingthebible
            "https://anchor.fm/s/6e1b1c0/podcast/rss", // shadowlands
            "http://mydigitalseminary.com/category/psalmcast/feed/podcast", // psalmcast
            "https://anchor.fm/s/526442c/podcast/rss", // messages-to-my-students
            "https://anchor.fm/s/9a68afc/podcast/rss", // goodlion
            "https://anchor.fm/s/79e2d50/podcast/rss", // testimony
            "https://anchor.fm/s/57d33a4/podcast/rss", // sermon-of-the-moment
            "https://anchor.fm/s/9290500/podcast/rss", // first-time-bible-teacher
            "https://anchor.fm/s/57d1dc4/podcast/rss", // anchor-of-hope
            "https://anchor.fm/s/fac544/podcast/rss", // ask-a-youth-pastor
            "http://feeds.feedburner.com/VoxHibernia", // vox
        ]
        var loadCount = 0 
        for url in info {
            fetcher.load(url: try! url.asURL()) { podcast, _ in
                guard let podcast = podcast else { return }
                DispatchQueue.main.async { [unowned self] in
                    self.add(podcast: podcast)
                    loadCount += 1
                    if loadCount == info.count {
                        self.delegate?.finishedLoading()
                    }
                }
            }
        }
    }

    private func add(podcast: Podcast) {
        if let index = network.firstIndex(where: { $0.rssUrl == podcast.rssUrl }) {
            network[index] = podcast
        } else {
            network.append(podcast)
        }
        network.sort { left, right in left.title < right.title }
        delegate?.didLoad(podcast: podcast)
    }

    var mostRecent: [Episode] {
        return network.flatMap { $0.episodes }.sorted { $0.date > $1.date }
    }
}
