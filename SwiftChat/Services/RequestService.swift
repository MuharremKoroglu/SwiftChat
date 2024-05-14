//
//  RequestService.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 14.05.2024.
//

import Foundation

enum RequestService {
    
    case contactsReuqest
    
    private var baseURL : URL {
        switch self {
        case .contactsReuqest:
            return URL(string: Constants.contactsBaseUrl)!
        }
    }
    
    private var path : String {
        switch self {
        case .contactsReuqest:
            return ""
        }
    }
    
    var httpMethod : String {
        switch self {
        case .contactsReuqest:
            return "GET"
        }
    }
    
    var httpHeader : [String : String] {
        switch self {
        case .contactsReuqest:
            return ["Content-Type": "application/json"]
        }
    }
    
    var url : URL {
        switch self {
        case .contactsReuqest:
            var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
            
            let data : ContactsRequestModel = ContactsRequestModel(
                results: 100,
                include: "name,picture,phone",
                nationality: "us",
                noinfo: "noinfo"
            )
            
            components?.queryItems = [
                URLQueryItem(name: ContactsRequestModel.CodingKeys.results.rawValue, value: "\(data.results)"),
                URLQueryItem(name: ContactsRequestModel.CodingKeys.include.rawValue, value: data.include),
                URLQueryItem(name: ContactsRequestModel.CodingKeys.nationality.rawValue, value: data.nationality),
                URLQueryItem(name: ContactsRequestModel.CodingKeys.noinfo.rawValue, value: data.noinfo)
            ]
            
            return components?.url ?? baseURL.appendingPathComponent(path)
            
        }
    }
    
}
