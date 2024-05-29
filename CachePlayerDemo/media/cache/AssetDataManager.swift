//
//  AssetDataManager.swift
//  CachePlayerDemo
//
//  Created by mikedeng on 2024/5/29.
//

import PINCache
import Foundation

protocol AssetDataManager {
    func retrieveAssetData() -> AssetData?
    func saveContentInformation(_ contentInformation: AssetDataContentInformation)
    func saveDownloadedData(_ data: Data, offset: Int)
    func mergeDownloadedDataIfIsContinuted(from: Data, with: Data, offset: Int) -> Data?
}

extension AssetDataManager {
    func mergeDownloadedDataIfIsContinuted(from: Data, with: Data, offset: Int) -> Data? {
        if offset <= from.count && (offset + with.count) > from.count {
            let start = from.count - offset
            var data = from
            data.append(with.subdata(in: start..<with.count))
            return data
        }
        return nil
    }
}

class PINCacheAssetDataManager: NSObject, AssetDataManager {
    
    static let Cache: PINCache = PINCache(name: "ResourceLoader")
    let cacheKey: String
    
    init(cacheKey: String) {
        self.cacheKey = cacheKey
        super.init()
    }
    
    static func setCache() {
        
    }
    
    func saveContentInformation(_ contentInformation: AssetDataContentInformation) {
        let assetData = AssetData()
        assetData.contentInformation = contentInformation
        PINCacheAssetDataManager.Cache.setObjectAsync(assetData, forKey: cacheKey, completion: nil)
    }
    
    func saveDownloadedData(_ data: Data, offset: Int) {
        guard let assetData = self.retrieveAssetData() else {
            return
        }
        
        if let mediaData = self.mergeDownloadedDataIfIsContinuted(from: assetData.mediaData, with: data, offset: offset) {
            assetData.mediaData = mediaData
            
            PINCacheAssetDataManager.Cache.setObjectAsync(assetData, forKey: cacheKey, completion: nil)
        }
    }
    
    func retrieveAssetData() -> AssetData? {
        guard let assetData = PINCacheAssetDataManager.Cache.object(forKey: cacheKey) as? AssetData else {
            return nil
        }
        return assetData
    }
}


