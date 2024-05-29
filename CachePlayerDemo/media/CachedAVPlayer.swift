//
//  CachedAVPlayer.swift
//  CachePlayerDemo
//
//  Created by mikedeng on 2024/5/28.
//

import AVFoundation

class CachedAVPlayer {
    private var player: AVPlayer
    private var loaderDelegate = ResourceLoaderDelegate()
    
    init() {
        self.player = AVPlayer()
    }

    func setupPlayerItem(with url: URL) {
        // Replace the scheme with a custom scheme
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.scheme = "cacheable"

        guard let customURL = components?.url else {
            return
        }

        let asset = AVURLAsset(url: customURL)
        asset.resourceLoader.setDelegate(loaderDelegate, queue: DispatchQueue.main)

        let playerItem = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: playerItem)
    }

    func play() {
        player.play()
    }
}
