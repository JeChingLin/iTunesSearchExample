
import Foundation
import Result

public func error(message: String) -> NSError {
    return Result<(), NSError>.error(message)
}
