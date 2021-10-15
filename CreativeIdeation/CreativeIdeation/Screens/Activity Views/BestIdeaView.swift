//
//  BestIdeaView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-10-08.
//

import SwiftUI

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

                // Background Stars VStack
                VStack {
                    HStack(alignment: .top) {
                        Star(size: 100, color: Color.red, inverted: true)
                        Spacer()
                        Star(size: 75, color: Color.purple)
                    }
                    HStack {
                        Star(size: 80, color: Color.yellow)
                            .padding(.trailing, 30)
                        Spacer()
                        Star(size: 90, color: Color.green, inverted: true)
                            .padding(.trailing, 30)
                    }
                    HStack(alignment: .bottom) {
                        Star(size: 60, color: Color.blue, inverted: true)
                            .padding(.leading, 30)
                        Spacer()
                        Star(size: 85, color: Color.orange)
                    }
                    HStack {
                        Star(size: 95, color: Color.green)
                            .padding(.trailing, 30)
                        Spacer()
                        Star(size: 70, color: Color.red, inverted: true)
                            .padding(.leading, 30)
                    }
                    HStack(alignment: .top) {
                        Star(size: 80, color: Color.purple, inverted: true)
                            .padding(.trailing, 30)
                        Spacer()
                        Star(size: 65, color: Color.yellow)
                            .padding(.leading, 30)
                    }
                    HStack(alignment: .bottom) {
                        Star(size: 75, color: Color.orange)
                            .padding(.trailing, 30)
                        Spacer()
                        Star(size: 95, color: Color.blue, inverted: true)
                            .padding(.leading, 30)
                    }
                }

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
