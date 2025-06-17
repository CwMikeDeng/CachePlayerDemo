//
//  ContentView.swift
//  CachePlayerDemo
//
//  Created by mikedeng on 2024/5/28.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    let player = AVPlayer()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            if let url = URL(string: "SamplePlayableUrl") {
                if CachingAVURLAsset.isSchemeSupport(url) {
                    let asset = CachingAVURLAsset(url: url)
                    let playItem = AVPlayerItem(asset: asset)
                    player.replaceCurrentItem(with: playItem)
                    player.play()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
