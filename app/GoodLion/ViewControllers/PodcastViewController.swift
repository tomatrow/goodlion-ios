//
//  PodcastViewController.swift
//  GoodLion
//
//  Created by AJ Caldwell on 3/9/19.
//  Copyright © 2019 Hesed Creative. All rights reserved.
//

import UIKit

class PodcastViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var podcast: Podcast? {
        didSet {
            configureView()
        }
    }

    private func configureView() {
        guard let tableView = tableView else { return }
        tableView.reloadData()
        navigationItem.title = podcast!.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(EpisodeListHeaderView.nib.self, forHeaderFooterViewReuseIdentifier: EpisodeListHeaderView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        configureView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let index = cell.tag
        let episode = podcast!.episodes[index]
        let controller = segue.destination as! EpisodeViewController
        controller.episode = episode
    }
}

extension PodcastViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return podcast?.episodes.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath)

        let episodeIndex = indexPath.row
        let episode = podcast!.episodes[episodeIndex]
        cell.textLabel!.text = episode.title
        cell.detailTextLabel!.text = episode.timeDescription
        cell.tag = episodeIndex

        return cell
    }
}

extension PodcastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        assert(section == 0)

        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: EpisodeListHeaderView.reuseIdentifier
        )
            as? EpisodeListHeaderView
        else {
            return nil
        }

        header.authorLabel.text = podcast!.author
        header.descriptionLabel.text = podcast!.description
        header.coverImageView.kf.setImage(with: podcast!.cover)

        return header
    }
}

extension Episode {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }

    var formattedDuration: String {
        let componentsFormatter = DateComponentsFormatter()
        componentsFormatter.allowedUnits = [.hour, .minute, .second]
        componentsFormatter.unitsStyle = .positional
        componentsFormatter.zeroFormattingBehavior = .dropLeading
        return componentsFormatter.string(from: duration)!
    }

    var timeDescription: String {
        return "\(formattedDate) - \(formattedDuration)"
    }
}
