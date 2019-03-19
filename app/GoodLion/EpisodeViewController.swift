//
//  EpisodeViewController.swift
//  GoodLion
//
//  Created by AJ Caldwell on 3/9/19.
//  Copyright © 2019 Hesed Creative. All rights reserved.
//

import SwiftAudio
import UIKit
import Kingfisher

// THe Library: https://github.com/jorgenhenrichsen/SwiftAudio

class EpisodeViewController: UIViewController {
    var episode: Episode? {
        didSet {
            configureView()
            loadPlayer()
        }
    }

    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var timeElapsedLebel: UILabel!
    @IBOutlet weak var scrubSlider: UISlider!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    let player = AudioPlayer()

    @IBAction func scrubberUpdated(_ sender: UISlider) {
        player.seek(to: TimeInterval(sender.value))
    }
    private func configureView() {
        guard let episode = episode, let coverImageView = coverImageView else { return }
        coverImageView.kf.setImage(with: episode.cover)
        scrubSlider.value = 0 
        scrubSlider.minimumValue = 0 
        scrubSlider.maximumValue = Float(episode.duration)
    }

    private func loadPlayer() {
        guard let episode = episode else { return }
        let url = episode.media.url
        try! AudioSessionController.shared.set(category: .playback)
        try! AudioSessionController.shared.activateSession()
        let audioItem = DefaultAudioItem(audioUrl: url.absoluteString, sourceType: .stream)
        try! player.load(item: audioItem, playWhenReady: false)
        player.event.stateChange.addListener(self) { state in
            DispatchQueue.main.async {
                self.playButton.setTitle(state.toggleActionDescription, for: .normal)
            }
        }
        player.event.secondElapse.addListener(self) { interval in
            print(interval)

            DispatchQueue.main.async {
                self.scrubSlider.value = Float(interval)
                self.timeElapsedLebel.text = interval.description
                self.timeRemainingLabel.text = (episode.duration - interval).description
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    @IBAction func buttonTapped(_: Any) {
        player.togglePlaying()
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
