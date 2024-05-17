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
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let serverResponse = response as? HTTPURLResponse, serverResponse.statusCode == 200 else {
                return .failure(URLError(.badServerResponse))
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            
            return .success(decodedData)
            
        }catch {
            return .failure(error)
        }
        
    }
     
}
