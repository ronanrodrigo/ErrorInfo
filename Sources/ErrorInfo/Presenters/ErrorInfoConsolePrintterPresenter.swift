import Combine
import Foundation

final class ErrorInfoConsolePrintterPresenter: ErrorInfoPresenter {
    func complete(with completion: Subscribers.Completion<ErrorInfoGatewayError>) {
        switch completion {
        case let .failure(error):
            print("🛑 Finished with a failure: \(error)")
            exit(1)
        case .finished:
            print("👋 That's it")
            exit(0)
        }
    }

    func present(_ errorInfos: [ErrorInfo]) {
        print(errorInfos.map(printErrorInfo).joined(separator: "\n--\n"))
    }

    private func printErrorInfo(_ errorInfo: ErrorInfo) -> String {
        """
           Platforms: \(platformIcons(errorInfo.platforms))
           Framework: \(errorInfo.framework)
         Header File: \(errorInfo.headerFile)
        Error symbol: \(errorInfo.code.symbol)
              osType: \(errorInfo.code.osType)
                  hx: \(errorInfo.code.hx)
              number: \(errorInfo.code.number)
         Description: \(errorInfo.description)
        """
    }

    private func platformIcons(_ platforms: [String]) -> String {
        platforms.reduce(into: [String]()) { (result, platform) in
            let icon: String
            switch platform {
            case "platform-ios":
                icon = "📱"
            case "platform-mac":
                icon = "🖥"
            case "platform-watch":
                icon = "⌚️"
            case "platform-tv":
                icon = "📺"
            default:
                icon = "🛑"
            }
            result.append(icon)
        }
        .joined(separator: " ")
    }
}
