import Combine

protocol ErrorInfoGateway {
    func find(by term: String) -> AnyPublisher<[ErrorInfo], ErrorInfoGatewayError>
}
