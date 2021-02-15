struct ErrorInfo {
    let platforms: [String]
    let framework: String
    let headerFile: String
    let code: Code
    let description: String

    struct Code {
        let symbol: String
        let osType: String
        let hx: String
        let number: String
    }
}
