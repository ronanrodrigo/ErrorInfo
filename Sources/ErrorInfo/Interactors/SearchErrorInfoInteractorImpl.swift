import Foundation
import Combine

final class SearchErrorInfoInteractorImpl: SearchErrorInfoInteractor {
    private let gateway: ErrorInfoGateway
    private let presenter: ErrorInfoPresenter
    private var cancellable: Cancellable?

    init(gateway: ErrorInfoGateway,
         presenter: ErrorInfoPresenter) {
        self.gateway = gateway
        self.presenter = presenter
    }

    func search(by term: String) {
        cancellable = gateway
            .find(by: term)
            .sink(receiveCompletion: { [presenter] in
                    presenter.complete(with: $0)
                },
                receiveValue: { [presenter] in
                    presenter.present($0)
                })
    }
}
