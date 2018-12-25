//
//  iTunesSearchApi.swift
//  iTunesSearchExample
//
//  Created by LinChe-Ching on 2018/12/22.
//  Copyright © 2018 Che-ching Lin. All rights reserved.
//

import Moya
import Alamofire
import Foundation

enum iTunesApi {
    case search(term : String)
}

extension iTunesApi : TargetType {
    var baseURL: URL {
        return URL(string: "https://itunes.apple.com")!
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }

    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .search(let term):
            let parameters: [String: Any] = ["term": term]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["accept": "application/json"]
    }
}

let apiProvider: MoyaProvider<iTunesApi> = {
    return MoyaProvider<iTunesApi>(manager: manager)
}()

let manager: Alamofire.SessionManager = {
    let manager = Alamofire.SessionManager.default
    
    manager.delegate.sessionDidReceiveChallenge = { session, challenge in
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            disposition = URLSession.AuthChallengeDisposition.useCredential
            credential = URLCredential(trust: challenge.protectionSpace.serverTrust! )
        } else {
            if challenge.previousFailureCount > 0 {
                disposition = .cancelAuthenticationChallenge
            } else {
                credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                
                if credential != nil {
                    disposition = .useCredential
                }
            }
        }
        return (disposition, credential)
    }
    return manager
}()
