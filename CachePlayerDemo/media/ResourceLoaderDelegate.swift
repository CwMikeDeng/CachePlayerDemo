//
//  ResourceLoaderDelegate.swift
//  CachePlayerDemo
//
//  Created by mikedeng on 2024/5/28.
//

import AVFoundation

class ResourceLoaderDelegate: NSObject, AVAssetResourceLoaderDelegate {
    private let cache = URLCache(memoryCapacity: 64 * 1024 * 1024, diskCapacity: 2 * 1024 * 1024 * 1024, diskPath: "mediaCache")
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        guard let url = loadingRequest.request.url else {
            return false
        }
        
        // Create a unique key for caching based on URL
        let cacheKey = url.absoluteString.replacingOccurrences(of: "cacheable", with: "https")
        
        if let dataRequest = loadingRequest.dataRequest {
            // Check if the data is in cache
            if let cachedResponse = cache.cachedResponse(for: URLRequest(url: URL(string: cacheKey)!)) {
                let data = cachedResponse.data
                dataRequest.respond(with: data)
                loadingRequest.finishLoading()
                return true
            }
            
            // Convert the custom URL scheme to a standard scheme
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.scheme = "https" // Or the original scheme of your media URL
            
            guard let originalURL = components?.url else {
                return false
            }
            
            // Create a new request with the original URL
            var request = URLRequest(url: originalURL)
            request.allHTTPHeaderFields = loadingRequest.request.allHTTPHeaderFields
            
            // Download the data
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self, let data = data, let response = response else {
                    loadingRequest.finishLoading(with: error)
                    return
                }
                
                // Cache the data
                let cachedResponse = CachedURLResponse(response: response, data: data)
                self.cache.storeCachedResponse(cachedResponse, for: URLRequest(url: URL(string: cacheKey)!))
                
                // Provide the data to the loading request
                dataRequest.respond(with: data)
                loadingRequest.finishLoading()
            }
            task.resume()
            
            return true
        }
        return false
    }
}
