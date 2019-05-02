//
//  EpisodeViewController.swift
//  GoodLion
//
//  Created by AJ Caldwell on 3/9/19.
//  Copyright © 2019 Hesed Creative. All rights reserved.
//

import SwiftAudio
import UIKit

// THe Library: https://github.com/jorgenhenrichsen/SwiftAudio

class EpisodeViewController: UIViewController {
    var episode: Episode? {
        didSet {
            configureView()
            loadPlayer()
        }
    }

    @IBOutlet var timeRemainingLabel: UILabel!
    @IBOutlet var timeElapsedLebel: UILabel!
    @IBOutlet var scrubSlider: UISlider!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var toolbar: UIToolbar!
    let player = AudioPlayer()

    @IBAction func scrubberUpdated(_ sender: UISlider) {
        player.seek(to: TimeInterval(sender.value))
    }

    private func configureView() {
        guard let episode = episode, let coverImageView = coverImageView else { return }
        coverImageView.setImage(from: episode.cover)
        scrubSlider.value = 0
        scrubSlider.minimumValue = 0
        scrubSlider.maximumValue = Float(episode.duration)
        timeElapsedLebel.text = playbackFormatter.string(from: 0)
        timeRemainingLabel.text = playbackFormatter.string(from: episode.duration)
        navigationItem.title = episode.title
    }

    private func loadPlayer() {
        guard let episode = episode else { return }
        let url = episode.media.url
        let audioItem = DefaultAudioItem(audioUrl: url.absoluteString, sourceType: .stream)
        try! player.load(item: audioItem, playWhenReady: false)

        player.event.stateChange.addListener(self) { state in

            DispatchQueue.main.async {
                let item: UIBarButtonItem.SystemItem
                item = state == .playing ? .pause : .play
                self.toolbar.items![2] = UIBarButtonItem(barButtonSystemItem: item, target: self, action: #selector(EpisodeViewController.playButtonTapped))
            }
        }
        player.event.secondElapse.addListener(self) { interval in
            print(interval)

            DispatchQueue.main.async {
                self.scrubSlider.value = Float(interval)

                self.timeElapsedLebel.text = self.playbackFormatter.string(from: interval)!
                self.timeRemainingLabel.text = self.playbackFormatter.string(from: episode.duration - interval)!
            }
        }
    }

    let playbackFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    @IBAction func skipTapped(_ sender: UIBarButtonItem) {
        let sign: Double = sender.title?.first! == "+" ? 1 : -1
        player.seek(to: player.currentTime + sign * 30.0)
    }

    @IBAction func playButtonTapped() {
        activateAudioSession()
        player.togglePlaying()
    }

    func activateAudioSession() {
        let audioSessionController = AudioSessionController.shared
        if !audioSessionController.audioSessionIsActive {
            try! audioSessionController.activateSession()
        }
    }
}

extension AudioPlayerState {
    var toggleActionDescription: String {
        switch self {
        case .playing:
            return "Pause"
        default:
            return "Play"
        }
    }
}
