import SwiftUI

struct ContentView: View {
    @State private var viewModel = EmojiMemoryGame()

    var body: some View {
        VStack(spacing: 12) {
            header
            themeBar
            board
        }
        .padding()
        .background(viewModel.theme.color.opacity(0.08).ignoresSafeArea())
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.theme.name)
                    .font(.title2.bold())
                    .foregroundStyle(viewModel.theme.color)
                Text("Score \(viewModel.score)")
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                withAnimation(.easeInOut(duration: 0.3)) { viewModel.newGame() }
            } label: {
                Label("New Game", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
            .tint(viewModel.theme.color)
        }
    }

    private var themeBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Theme.all) { theme in
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) { viewModel.select(theme) }
                    } label: {
                        VStack(spacing: 2) {
                            Image(systemName: theme.symbol).font(.title3)
                            Text(theme.name).font(.caption2)
                        }
                        .frame(width: 64, height: 52)
                    }
                    .buttonStyle(.bordered)
                    .tint(theme.id == viewModel.theme.id ? theme.color : .gray)
                }
            }
            .padding(.horizontal, 2)
        }
    }

    private var board: some View {
        AspectVGrid(viewModel.cards, aspectRatio: 2.0 / 3.0) { card in
            CardView(card: card, color: viewModel.theme.color)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.4)) { viewModel.choose(card) }
                }
                .padding(3)
        }
        .overlay {
            if viewModel.isGameOver {
                gameOverBanner
            }
        }
    }

    private var gameOverBanner: some View {
        VStack(spacing: 12) {
            Text("All matched!").font(.headline)
            Text("Score \(viewModel.score)").font(.title.bold())
            Button("Play Again") {
                withAnimation(.easeInOut(duration: 0.3)) { viewModel.newGame() }
            }
            .buttonStyle(.borderedProminent)
            .tint(viewModel.theme.color)
        }
        .padding(24)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}
