//
//  ViewController.swift
//  GoodLion
//
//  Created by AJ Caldwell on 3/6/19.
//  Copyright © 2019 Hesed Creative. All rights reserved.
//

import Alamofire
import FeedKit
import Kingfisher
import SwiftAudio
import UIKit

class NetworkViewController: UIViewController {
    var podcasts = [Podcast]() {
        didSet {
            collectionView.reloadData()
        }
    }

    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
		loadPodcasts()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try! AudioSessionController.shared.set(category: .playback)
    }
}

extension NetworkViewController: UICollectionViewDelegate {}

extension NetworkViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return podcasts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PodcastCell", for: indexPath) as! CoverCell

        let podcastIndex = indexPath.row
        let podcast = podcasts[podcastIndex]
        cell.button.tag = podcastIndex

        cell.imageView.kf.setImage(with: podcast.cover)

        return cell
    }
}

extension NetworkViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as! UIButton
        let index = button.tag
        let destController = segue.destination as! PodcastViewController
        destController.podcast = podcasts[index]
    }
	
	func loadPodcasts() {
	
        let all = [ // missing some 
            "https://anchor.fm/s/fac544/podcast/rss",
            "https://anchor.fm/s/526442c/podcast/rss",
            "https://anchor.fm/s/9290500/podcast/rss",
            "https://anchor.fm/s/57d33a4/podcast/rss",
            "https://feeds.feedburner.com/VoxHibernia?format=xml",
            "http://mydigitalseminary.com/category/psalmcast/feed/podcast/",
            "https://beyondreadingthebible.com/feed/podcast",
            ]
        
        all.map{ AF.download($0) }.forEach { task in 
            task.responseData() { response in
                guard let data = response.result.value else { return }
                let parser = FeedParser(data: data)
                parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
                    DispatchQueue.main.async {
                        guard case .rss(let feed) = result else { return }
                        let podcast = Podcast(rssFeed: feed)
                        self.podcasts.append(podcast)
                        if self.podcasts.count == all.count {
                            
                            print("hello")
                        }
                    }
                }
            }
        }
    }
}
