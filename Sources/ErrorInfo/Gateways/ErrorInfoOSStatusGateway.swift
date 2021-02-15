import Combine
import Foundation
import SwiftSoup

final class ErrorInfoOSStatusGateway: ErrorInfoGateway {
    private let subject = PassthroughSubject<[ErrorInfo], ErrorInfoGatewayError>()

    func find(by term: String) -> AnyPublisher<[ErrorInfo], ErrorInfoGatewayError> {
        Deferred {
            Future { promise in
                DispatchQueue.global().async { [weak self] in
                    do {
                        let errorInfos: [ErrorInfo] = try self?.find(by: term) ?? []
                        promise(.success(errorInfos))
                    } catch {
                        if let error = error as? ErrorInfoGatewayError {
                            promise(.failure(error))
                        } else {
                            promise(.failure(.unknown(error)))
                        }
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    private let osStatusBaseURL = "https://osstatus.com/search/results"

    private func find(by term: String) throws -> [ErrorInfo] {
        guard let url = URL(string: "\(osStatusBaseURL)?platform=all&framework=all&search=\(term)") else { return [] }
        var errorInfos = [ErrorInfo]()

        let osStatusContent = try String(contentsOf: url)
        let document = try SwiftSoup.parse(osStatusContent)
        if try !document.select(".danger").isEmpty() {
            throw ErrorInfoGatewayError.notFound
        }

        try document.select("table tbody tr").forEach { tr in
            var platforms: [String]?
            var framework: String?
            var headerFile: String?
            var description: String?
            var symbol: String?
            var osType: String?
            var hx: String?
            var number: String?

            try tr.select("td").forEach { td in
                platforms = platforms ?? elements(on: td, with: "platform")
                framework = framework ?? select(on: td, with: "ec-framework")
                headerFile = headerFile ?? select(on: td, with: "ec-header_file")
                description = description ?? select(on: td, with: "ec-description")
                symbol = symbol ?? select(on: td, with: "value-symbol")
                osType = osType ?? select(on: td, with: "value-ostype")
                hx = hx ?? select(on: td, with: "value-hex")
                number = number ?? select(on: td, with: "value-number")
            }
            let errorInfo = try makeErorInfo(platforms: platforms,
                                             framework: framework,
                                             headerFile: headerFile,
                                             description: description,
                                             symbol: symbol,
                                             osType: osType,
                                             hx: hx,
                                             number: number)
            errorInfos.append(errorInfo)
        }
        return errorInfos
    }


    private func makeErorInfo(platforms: [String]?,
                              framework: String?,
                              headerFile: String?,
                              description: String?,
                              symbol: String?,
                              osType: String?,
                              hx: String?,
                              number: String?) throws -> ErrorInfo {
        let platforms = platforms ?? [""]
        let framework = framework ?? ""
        let headerFile = headerFile ?? ""
        let description = description ?? ""
        let symbol = symbol ?? ""
        let osType = osType ?? ""
        let hx = hx ?? ""
        let number = number ?? ""

        let code = ErrorInfo.Code(symbol: symbol, osType: osType, hx: hx, number: number)
        let osStatus = ErrorInfo(platforms: platforms, framework: framework, headerFile: headerFile, code: code, description: description)

        return osStatus
    }

    private func elements(on parent: Element, with className: String) -> [String]? {
        do {
            let elements = try parent.getElementsByAttributeValueContaining("class", className)
            let elementVaues = try elements.reduce(into: [String]()) { (result, element) in
                let platformName = try element.className()
                result.append(platformName)
            }
            return elementVaues.isEmpty ? nil : elementVaues
        } catch {
            return nil
        }
    }

    private func select(on parent: Element, with className: String) -> String? {
        do {
            let element = try parent.select(".\(className)")
            let elementText = try element.text()
            return elementText.isEmpty ? nil : elementText
        } catch {
            return nil
        }
    }
}
