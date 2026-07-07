import SwiftUI

/// garage charcoal with a safety-orange accent
enum Theme {
    static let primary = Color(red: 0.169, green: 0.169, blue: 0.169)
    static let accent = Color(red: 0.910, green: 0.639, blue: 0.141)
    static let background = Color(.systemBackground)
    static let cardBackground = Color(.secondarySystemBackground)
    static let titleFont = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let headingFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
}
