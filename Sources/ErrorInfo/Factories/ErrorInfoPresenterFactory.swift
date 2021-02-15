final class ErrorInfoPresenterFactory {
    private init() { }

    static func make() -> ErrorInfoPresenter {
        ErrorInfoConsolePrintterPresenter()
    }
}
