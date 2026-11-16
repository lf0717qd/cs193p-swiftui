import SwiftUI

/// 主题：新增一个主题只需在 `Theme.all` 里加一行。
struct Theme: Identifiable {
    let id: String
    let name: String
    let symbol: String
    let emojis: [String]
    let pairs: Int
    let color: Color

    init(name: String, symbol: String, emojis: [String], pairs: Int? = nil, color: Color) {
        self.id = name
        self.name = name
        self.symbol = symbol
        self.emojis = emojis
        self.pairs = min(pairs ?? emojis.count, emojis.count)
        self.color = color
    }

    static let all: [Theme] = [
        Theme(name: "Faces", symbol: "face.smiling", emojis: ["😀", "😎", "🥲", "😡", "🤯", "🥶", "🤠", "👻", "🤖", "💩", "🎃", "😈"], pairs: 8, color: .orange),
        Theme(name: "Animals", symbol: "pawprint", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮"], pairs: 8, color: .green),
        Theme(name: "Weather", symbol: "cloud.sun", emojis: ["☀️", "🌤️", "⛅️", "🌧️", "⛈️", "❄️", "🌪️", "🌈", "☔️", "🌊"], pairs: 6, color: .blue),
        Theme(name: "Food", symbol: "fork.knife", emojis: ["🍎", "🍊", "🍋", "🍉", "🍇", "🍓", "🍒", "🍑", "🥝", "🍍"], pairs: 6, color: .pink),
        Theme(name: "Vehicles", symbol: "car", emojis: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚐"], pairs: 6, color: .red),
        Theme(name: "Sports", symbol: "figure.run", emojis: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🎱", "🏓", "🏸"], pairs: 6, color: .purple),
    ]
}
