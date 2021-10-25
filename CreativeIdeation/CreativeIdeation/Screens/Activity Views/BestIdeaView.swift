//
//  BestIdeaView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-10-08.
//

import SwiftUI
import ConfettiView

struct BestIdeaView: View {

    @EnvironmentObject var sessionItemViewModel: SessionItemViewModel
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @Environment(\.colorScheme) var colorScheme

    let columns = [
        GridItem(.adaptive(minimum: 300))]

    @Binding var bestIdeas: [StickyNote]

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                // Confetti!
                ConfettiView(confetti: [
                    .shape(.triangle, .red),
                    .shape(.square, .green),
                    .shape(.circle, UIColor.init(red: 0, green: 0.5, blue: 1, alpha: 1)),
                    .text("⭐")
                ])

                // Best Stickies
                HStack {
                    VStack {
                        Text("The voters have spoken!")
                            .font(.largeTitle)
                            .padding()

                        if bestIdeas.count < 2 {
                            Text("...and the best idea from this session was:")
                                .font(.title)
                                .padding(.bottom)
                        } else {
                            Text("...and it's a tie! The best ideas were:")
                                .font(.title)
                        }

                        Spacer()

                        if bestIdeas.count == 1 {
                            BestIdea(chosenColor: bestIdeas[0].chosenColor!, input: bestIdeas[0].input)
                                .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.5)
                        } else if bestIdeas.count > 1 {
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVStack {
                                    ForEach(bestIdeas) { idea in
                                        BestIdea(chosenColor: idea.chosenColor!, input: idea.input)
                                            .frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.4)
                                            .padding(50)
                                    }
                                }
                            }
                        }

                        Spacer()

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                sessionItemViewModel.getBestIdeas(itemIds: sessionViewModel.getBestIds())
            }
        }
    }
}

struct BestIdeaView_Previews: PreviewProvider {
    static var previews: some View {
        BestIdeaView(bestIdeas: .constant([]))
    }
}
