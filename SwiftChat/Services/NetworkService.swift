//
//  NetworkService.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.05.2024.
//

import Foundation

struct NetworkService {
    
    func networkService <T : Codable> (service : RequestService, data : T.Type) async -> Result<T, Error>{
        
        do {
            
            var request = URLRequest(url: service.url)
            request.httpMethod = service.httpMethod
            request.allHTTPHeaderFields = service.httpHeader
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            
            return .success(decodedData)
            
        }catch {
            return .failure(error)
        }
        
    }
     
}
