
import ReactiveSwift
import Result

func withState<State, Error>(state: SignalProducer<State?, NoError>, transform: @escaping (State) -> SignalProducer<State, Error>) -> SignalProducer<State, Error> {
    return state
        .skipNil()
        .take(first: 1)
        .promoteError(Error.self)
        .flatMap(.latest, transform)
}

func makeSideEffectTask<Value, Error>(operation: @escaping () -> Void) -> SignalProducer<Value, Error> {
    return SignalProducer.empty
        .on(completed: operation)
}
