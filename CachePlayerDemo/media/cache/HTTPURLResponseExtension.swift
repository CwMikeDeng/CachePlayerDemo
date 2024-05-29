//
//  HTTPURLResponseExtension.swift
//  CachePlayerDemo
//
//  Created by mikedeng on 2024/5/29.
//

import CoreServices
import Foundation

extension HTTPURLResponse {
    func parseContentLengthFromContentRange() -> Int64? {
        let contentRangeKeys: [String] = [
            "Content-Range",
            "content-range",
            "Content-range",
            "content-Range"
        ]
        
        var rangeString: String?
        for key in contentRangeKeys {
            if let value = self.allHeaderFields[key] as? String {
                rangeString = value
                break
            }
        }
        
        guard let rangeString = rangeString,
              let contentLengthString = rangeString.split(separator: "/").map({String($0)}).last,
              let contentLength = Int64(contentLengthString) else {
            return nil
        }
        
        return contentLength
    }
    
    func parseAcceptRanges() -> Bool? {
        let contentRangeKeys: [String] = [
            "Accept-Ranges",
            "accept-ranges",
            "Accept-ranges",
            "accept-Ranges"
        ]
        
        var rangeString: String?
        for key in contentRangeKeys {
            if let value = self.allHeaderFields[key] as? String {
                rangeString = value
                break
            }
        }
        
        guard let rangeString = rangeString else {
            return nil
        }
        
        return rangeString == "bytes" || rangeString == "Bytes"
    }
    
    func mimeTypeUTI() -> String? {
        guard let mimeType = self.mimeType,
           let contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return nil
        }
        
        return contentType as String
    }
}
