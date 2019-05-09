//
//  ViewController.swift
//  GoodLion
//
//  Created by AJ Caldwell on 3/6/19.
//  Copyright © 2019 Hesed Creative. All rights reserved.
//

import UIKit
import AVFoundation

class NetworkViewController: UIViewController {
    let networkController = NetworkController()

    @IBOutlet var leadingMarginConstraint: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        networkController.delegate = self
        networkController.load()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
    }
}

extension NetworkViewController: UICollectionViewDelegate {}

extension NetworkViewController: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        switch indexPath.section {
        case 0:
            return CGSize(width: width, height: width / 4)
        case 1:
            let length = (width - leadingMarginConstraint.constant) / 2
            return CGSize(width: length, height: length)
        default:
            assert(false)
        }
    }
}

extension NetworkViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return min(networkController.mostRecent.count, 3)
        case 1:
            return networkController.network.count
        default:
            assert(false)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
            let episode = networkController.mostRecent[row]
            cell.imageView.setImage(from: episode.cover)
            cell.titleLabel.text = episode.title
            cell.subtitleLabel.text = episode.timeDescription
            cell.tag = row
            return cell
        } else if section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PodcastCell", for: indexPath) as! CoverCell

            let podcast = networkController.network[row]
            cell.tag = row

            cell.imageView.setImage(from: podcast.cover)

            return cell
        } else {
            assert(false)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { fatalError("Invalid element type") }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NetworkHeaderView", for: indexPath) as! NetworkHeaderView
        headerView.titleLabel.text = indexPath.section == 0 ? "Recent Episodes" : "Shows"
        return headerView
    }
}

extension NetworkViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? CoverCell {
            let index = cell.tag
            let destController = segue.destination as! PodcastViewController
            destController.podcast = networkController.network[index]
        } else if let cell = sender as? EpisodeCell {
            let index = cell.tag
            let destController = segue.destination as! EpisodeViewController
            destController.episode = networkController.mostRecent[index]
        } else {
            assert(false)
        }
    }
}

extension NetworkViewController: NetworkControllerDelegate {
    func didLoad(podcast _: Podcast) {
    }
    func finishedLoading() {
        collectionView.reloadData()
    }
}
