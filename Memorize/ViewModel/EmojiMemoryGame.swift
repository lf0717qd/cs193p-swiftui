import SwiftUI
import Observation

/// 视图模型：持有当前主题与游戏状态，对外只暴露只读数据 + 意图方法。
@Observable
final class EmojiMemoryGame {
    private(set) var theme: Theme
    private var model: MemoryGame<String>

    var cards: [MemoryGame<String>.Card] { model.cards }
    var score: Int { model.score }
    var isGameOver: Bool { model.isGameOver }

    init() {
        let theme = Theme.all.randomElement() ?? Theme.all[0]
        self.theme = theme
        self.model = Self.makeGame(for: theme)
    }

    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }

    func shuffle() {
        model.shuffle()
    }

    func newGame() {
        let next = Theme.all.randomElement() ?? Theme.all[0]
        theme = next
        model = Self.makeGame(for: next)
    }

    func select(_ newTheme: Theme) {
        theme = newTheme
        model = Self.makeGame(for: newTheme)
    }

    private static func makeGame(for theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        let pairs = min(theme.pairs, emojis.count)
        return MemoryGame(numberOfPairs: pairs) { index in
            emojis[index % emojis.count]
        }
    }
}
