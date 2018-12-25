//
//  SearchItunesMusicViewModel.swift
//  iTunesSearchExample
//
//  Created by LinChe-Ching on 2018/12/22.
//  Copyright © 2018 Che-ching Lin. All rights reserved.
//

import Foundation
import enum Result.Result
import ReactiveSwift
import ReactiveMoya
import Moya
import Alamofire

final class SearchItunesMusicViewModel {
    
    enum Intent {
        case updateTerm(term:String?)
        case searchTerm
    }
    
    struct State {
        var result:SongResults?
        var term:String?
        init(result: SongResults? = nil) {
            self.result = result
        }
        init(term: String? = nil) {
            self.term = term
        }
        init() {
        }
    }
    
    fileprivate struct Service  {
        let provider:MoyaProvider<iTunesApi>
    }
    
    var state = MutableProperty<State?>(nil)
    private let service:Service
    
    lazy var initialAction:Action<Void, State, NSError> = Action { [service = self.service] _ in
        return makeInitialTask()
    }
    
    lazy var action: Action<Intent, State, NSError> = Action { [state = self.state, service = self.service] intent in
        return withState(state: state.producer) { state in
            return makeTask(intent: intent, state: state, service: service)
        }
    }
    
    init(provider: MoyaProvider<iTunesApi>) {
        service = Service(provider: provider)
        state <~ Signal.merge(initialAction.values, action.values)
    }
}

private typealias Intent = SearchItunesMusicViewModel.Intent
private typealias State = SearchItunesMusicViewModel.State
private typealias Service = SearchItunesMusicViewModel.Service
private typealias Task = SignalProducer<State, NSError>

private func makeInitialTask() -> Task {
    return Task(value: State())
}

private func makeTask(intent: Intent, state: State, service: Service) -> Task {
    switch intent {
    case .searchTerm:
        return makeSearchTermTask(service, state: state)
    case .updateTerm(let term):
        return Task(value: State(term: term))
    }
}

private func makeSearchTermTask(_ service:Service, state: State) -> Task{
    return service.provider.reactive.request(.search(term: state.term ?? "" ))
        .filterSuccessfulStatusCodes()
        .mapError{ _ in error(message: "Failed to play.") }
        .attemptMap(decode)
        .map(State.init)
}

private func decode(response: Response) -> Result<SongResults, NSError> {
    return Result {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let result = try decoder.decode(SongResults.self, from: response.data)
        return result
    }
}
