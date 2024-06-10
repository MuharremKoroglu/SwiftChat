//
//  SCImageDownloader.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 16.05.2024.
//

import Foundation

final class SCImageDownloaderManager {
    
    static let shared : SCImageDownloaderManager = SCImageDownloaderManager()
    private init () {}
    
    private let downloadedImageCache = NSCache<NSString,NSData>()
    
    
    func downloadImage (imageUrl : URL) async -> Result<Data,Error> {
        
        let key = imageUrl.absoluteString as NSString
        
        if let data = downloadedImageCache.object(forKey: key) {
            return .success(data as Data)
        }
        
        
        do {
            let (data,response) = try await URLSession.shared.data(from: imageUrl)
            
            guard let serverResponse = response as? HTTPURLResponse, serverResponse.statusCode == 200 else {
                return .failure(URLError(.badServerResponse))
            }
            
            let imageValue = data as NSData
            
            self.downloadedImageCache.setObject(imageValue, forKey: key)
            
            return .success(data)
            
        }catch {
            return .failure(error)
        }
    }
    
}
