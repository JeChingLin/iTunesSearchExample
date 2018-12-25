
import Foundation

func always<Value, A>(_ value: Value) -> (A) -> Value {
    return { _ in value }
}
