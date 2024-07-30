import IsometrikStream

final public class CustomErrorHandler {

    static public func getErrorMessage(_ error: ISMLiveAPIError) -> String {
        
        switch error {
        case .noResultsFound(let int):
            return "\(int): ResultNotFound"
        case .networkError(let error):
            return "\(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response"
        case .httpError(_, let error):
            if let errorMessage = error?.readableErrorMessage {
                return errorMessage
            } else {
                return "HTTP error occurred"
            }
        default:
            return "Unknown error"
        }
    }
}
