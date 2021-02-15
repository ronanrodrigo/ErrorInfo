final class ErrorInfoGatewayFactory {
    private init() { }

    static func make() -> ErrorInfoGateway {
        ErrorInfoOSStatusGateway()
    }
}
