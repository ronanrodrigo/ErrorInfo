final class SearchErrorInfoInteractorFactory {
    private init() { }

    static func make() -> SearchErrorInfoInteractor {
        SearchErrorInfoInteractorImpl(gateway: ErrorInfoGatewayFactory.make(),
                                      presenter: ErrorInfoPresenterFactory.make())
    }
}
