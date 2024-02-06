import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: String? { get }
}

final class PlayBackPresenter {
    var playerVC: PlayerViewController?
    static let shared = PlayBackPresenter()
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    var index = 0
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?

    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if let player = self.playerQueue, !tracks.isEmpty {
            return tracks[index]
        }
        return nil
    }

    func startPlayback(from viewController: UIViewController, track: AudioTrack) {
        guard let url = URL(string: track.preview_url ?? "") else { return }
        player = AVPlayer(url: url)
        player?.volume = 0.0
        self.track = track
        self.tracks = []
        let vc = PlayerViewController()
        vc.title=track.name
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
    }

    func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]) {
        self.tracks = tracks
        self.track = nil
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap { track in
            guard let url = URL(string: track.preview_url ?? "") else {
                return nil
            }
            return nil
        })
        self.playerQueue?.volume = 0
        self.playerQueue?.play()
        
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        self.playerVC = vc
    }

}

extension PlayBackPresenter: PlayerViewControllerDelegate {
    func didSlideSlider(_ value: Float) {
        player?.volume = value
        playerQueue?.volume = value
    }

    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        } else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }

    func didTapForward() {
        if tracks.isEmpty {
            player?.pause()
        }  else if let player = playerQueue {
            playerQueue?.advanceToNextItem()
            index += 1
            playerVC?.refreshUI()
        }
    }

    func didTapBackwards() {
        if tracks.isEmpty {
            player?.pause()
        } else if let player = playerQueue {
            playerQueue?.advanceToNextItem()
            index -= 1
            playerVC?.refreshUI()
        }
    }
}

extension PlayBackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }

    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }

    var imageURL: String? {
        return currentTrack?.album?.images.first?.url
    }
}
