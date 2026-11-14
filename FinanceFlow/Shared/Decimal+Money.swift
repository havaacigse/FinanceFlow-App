import Foundation

extension Decimal {
    init?(userInput text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let separatorCount = trimmed.filter { $0 == "," || $0 == "." }.count
        guard separatorCount <= 1 else { return nil }

        let normalized = trimmed.replacingOccurrences(of: ",", with: ".")
        let components = normalized.split(separator: ".", omittingEmptySubsequences: false)
        guard components.count <= 2,
              components.allSatisfy({ !$0.isEmpty && $0.allSatisfy(\.isNumber) }) else {
            return nil
        }
        if components.count == 2 {
            guard components[1].count <= 2 else { return nil }
        }

        guard let value = Decimal(string: normalized) else { return nil }
        self = value
    }

    func formattedAsCurrency() -> String {
        formatted(.currency(code: "TRY").locale(.current))
    }

    func roundedToInt() -> Int {
        var rounded = Decimal()
        var value = self
        NSDecimalRound(&rounded, &value, 0, .plain)
        return NSDecimalNumber(decimal: rounded).intValue
    }
}
