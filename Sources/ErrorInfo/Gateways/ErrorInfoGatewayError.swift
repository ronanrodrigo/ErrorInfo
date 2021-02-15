enum ErrorInfoGatewayError: Error, CustomStringConvertible {
    case unknown(Error), notFound

    var description: String {
        switch self {
        case .notFound:
            return "Not found"
        case let .unknown(error):
            return "Unknown \(String(describing: error))"
        }
    }
}
