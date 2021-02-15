import Darwin
import Foundation

if CommandLine.arguments.count < 2 {
    print("Please, inform a search term"); exit(1)
}

let term = CommandLine.arguments[1]
let interactor = SearchErrorInfoInteractorFactory.make()
interactor.search(by: term)

RunLoop.main.run()
