//
//  PodcastViewController.swift
//  GoodLion
//
//  Created by AJ Caldwell on 3/9/19.
//  Copyright © 2019 Hesed Creative. All rights reserved.
//

import UIKit

class PodcastViewController: UIViewController {
    var podcast: Podcast? {
        didSet {
            configureView()
        }
    }

    @IBOutlet var collectionView: UICollectionView!

    private func configureView() {
        guard let _ = podcast,
            let collectionView = collectionView
        else { return }

        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        configureView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as! UIButton
        let index = button.tag
        let episode = podcast!.episodes[index]
        let controller = segue.destination as! EpisodeViewController
        controller.episode = episode
    }
}

extension PodcastViewController: UICollectionViewDelegate {}

extension PodcastViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return podcast?.episodes.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PodcastCell", for: indexPath) as! CoverCell

        let episodeIndex = indexPath.row
        let episode = podcast!.episodes[episodeIndex]
        cell.button.tag = episodeIndex

        cell.imageView.kf.setImage(with: episode.cover)

        return cell
    }
}
