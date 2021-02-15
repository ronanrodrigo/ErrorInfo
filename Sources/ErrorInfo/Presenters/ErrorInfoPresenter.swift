import Combine

protocol ErrorInfoPresenter {
    func present(_ errorInfos: [ErrorInfo])
    func complete(with completion: Subscribers.Completion<ErrorInfoGatewayError>)
}
