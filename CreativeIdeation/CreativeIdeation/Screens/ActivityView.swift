//
//  ActivityView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI
import PencilKit

struct ActivityView: View {

    @EnvironmentObject var sessionItemViewModel: SessionItemViewModel

    let colorArray = [Color.init(red: 0.9, green: 0, blue: 0),
                      Color.init(red: 0, green: 0.9, blue: 0),
                      Color.init(red: 0, green: 0.7, blue: 0.9),
                      Color.init(red: 0.9, green: 0.9, blue: 0),
                      Color.init(red: 0.9, green: 0.45, blue: 0.9)]

    let shadowColor = Color.init(red: 0.3, green: 0.3, blue: 0.3)
    // @State private var canvasView = PKCanvasView()

    @State private var selectedColor = -1
    @State private var randomizeColor: Bool = true

    @State private var ideas: [String] = []
    @State private var ideasIndex = 0
    @State private var idea = ""

    @Binding var showActivity: Bool

    var body: some View {
        ZStack {
            // Whatever view we use for the canvas will be placed here,
            // so that all other elements are placed above it on the zstack

            // PKCanvas(canvasView: $canvasView) // Creates the canvasView

            ForEach(sessionItemViewModel.stickyNotes) { note in
                note
            }

            VStack {
                HStack {

                    Button {
                        showActivity = false
                        sessionItemViewModel.resetModel()
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)

                            Circle().stroke(lineWidth: 2)
                                .foregroundColor(.black)
                                .frame(width: 80, height: 80)

                            Image(systemName: "arrow.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                        }
                        .frame(width: 85, height: 85)
                        .clipped()
                        .padding(.leading, 45)
                        .padding(.top, 20)
                        .shadow(color: shadowColor, radius: 4, y: 4)
                    }

                    Spacer()
                }
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Button {
                            let newColor = randomizeColor ? Int.random(in: 0..<5) : selectedColor
                            sessionItemViewModel.createItem(color: newColor)

                        } label: {
                            VStack(spacing: 0) {
                                Rectangle()
                                    .foregroundColor((selectedColor != -1) ?
                                                        colorArray[selectedColor].darker(by: 10) :
                                                        colorArray[0].darker(by: 10))
                                    .frame(width: 90, height: 20)

                                Image(systemName: "plus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                    .frame(width: 90, height: 70)
                                    .background((selectedColor != -1) ?
                                                    colorArray[selectedColor] :
                                                    colorArray[0])
                            }
                            .cornerRadius(18)
                            .shadow(color: shadowColor, radius: 6, y: 4)
                            .padding()
                        }

                        VStack(spacing: 10) {
                            HStack(spacing: 10) {
                                Button {
                                    if sessionItemViewModel.selectedSticky != nil {
                                        sessionItemViewModel.colorSelected(color: 0)
                                    } else {
                                        selectedColor = 0
                                        randomizeColor = false
                                    }

                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(colorArray[0])
                                            .frame(width: 25, height: 25)
                                        if selectedColor == 0 {
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                                .frame(width: 19, height: 19)
                                        }
                                    }
                                }

                                Button {
                                    if sessionItemViewModel.selectedSticky != nil {
                                        sessionItemViewModel.colorSelected(color: 1)
                                    } else {
                                        selectedColor = 1
                                        randomizeColor = false
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(colorArray[1])
                                            .frame(width: 25, height: 25)
                                        if selectedColor == 1 {
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                                .frame(width: 19, height: 19)
                                        }
                                    }
                                }
                            }
                            HStack(spacing: 10) {
                                Button {
                                    if sessionItemViewModel.selectedSticky != nil {
                                        sessionItemViewModel.colorSelected(color: 2)
                                    } else {
                                        selectedColor = 2
                                        randomizeColor = false
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(colorArray[2])
                                            .frame(width: 25, height: 25)
                                        if selectedColor == 2 {
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                                .frame(width: 19, height: 19)
                                        }
                                    }
                                }

                                Button {
                                    if sessionItemViewModel.selectedSticky != nil {
                                        sessionItemViewModel.colorSelected(color: 3)
                                    } else {
                                        selectedColor = 3
                                        randomizeColor = false
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(colorArray[3])
                                            .frame(width: 25, height: 25)
                                        if selectedColor == 3 {
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                                .frame(width: 19, height: 19)
                                        }
                                    }
                                }
                            }
                            HStack(spacing: 10) {
                                Button {
                                    if sessionItemViewModel.selectedSticky != nil {
                                        sessionItemViewModel.colorSelected(color: 4)
                                    } else {
                                        selectedColor = 4
                                        randomizeColor = false
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(colorArray[4])
                                            .frame(width: 25, height: 25)
                                        if selectedColor == 4 {
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                                .frame(width: 19, height: 19)
                                        }
                                    }
                                }
                            }

                            Button {
                                if sessionItemViewModel.selectedSticky == nil {
                                    // randomize button
                                    if !randomizeColor {
                                        selectedColor = -1
                                        randomizeColor = true
                                    }

                                } else {
                                    // confirm button, deselect
                                    sessionItemViewModel.updateItem(itemId: sessionItemViewModel.selectedItem!.itemId)
                                    sessionItemViewModel.clearSelected()
                                }
                            } label: {
                                if sessionItemViewModel.selectedSticky == nil {
                                    ZStack {
                                        Image(systemName: "questionmark")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(randomizeColor ? Color.white : Color.black)
                                            .frame(width: 60, height: 30)
                                            .background(randomizeColor ? Color.black : Color.white)
                                            .cornerRadius(5)
                                            .padding(.top, 5)

                                        if randomizeColor {
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.white, lineWidth: 2)
                                                .frame(width: 54, height: 24)
                                                .padding(.top, 5)
                                        } else {
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.black, lineWidth: 2)
                                                .frame(width: 60, height: 30)
                                                .padding(.top, 5)
                                        }
                                    }
                                } else {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.white)
                                        .frame(width: 60, height: 30)
                                        .background(Color.green)
                                        .cornerRadius(5)
                                        .padding(.top, 5)
                                }
                            }

                            Button {
                                if sessionItemViewModel.selectedSticky != nil {
                                    // delete button
                                    sessionItemViewModel.deleteSelected()
                                }
                            } label: {
                                    Image(systemName: "trash.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                        .frame(width: 60, height: 30)
                                        .background(sessionItemViewModel.selectedSticky != nil ?
                                                        Color.red : Color.init(red: 1.0,
                                                                               green: 0.65,
                                                                               blue: 0.65))
                                        .cornerRadius(5)
                            }
                            .disabled(sessionItemViewModel.selectedSticky == nil)
                        }
                        .frame(minWidth: 80, minHeight: 200)
                        .background(Color.white)
                        .clipped()
                        .cornerRadius(15)
                        .shadow(color: shadowColor, radius: 6, y: 4)
                        .padding(.trailing, 21)

                        HStack {
                            // Suggestion carousel
                            if sessionItemViewModel.generatedIdeas.count > 0 {
                                HStack {
                                    // Cycle left
                                    Button {
                                        if ideasIndex > 0 {
                                            ideasIndex -= 1
                                        } else {
                                            ideasIndex = sessionItemViewModel.generatedIdeas.count - 1
                                        }
                                        idea = sessionItemViewModel.generatedIdeas[ideasIndex]
                                    } label: {
                                        Image(systemName: "chevron.left")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                    }

                                    // Idea Text
                                    Menu(sessionItemViewModel.generatedIdeas[ideasIndex]) {
                                        // Copy Text
                                        Button {
                                            UIPasteboard.general.string =
                                                sessionItemViewModel.generatedIdeas[ideasIndex]
                                        } label: {
                                            Label("Copy", systemImage: "doc.on.doc")
                                        }
                                        // Close Ideas
                                        Button {
                                            sessionItemViewModel.clearIdeas()
                                        } label: {
                                            Label("Close", systemImage: "xmark")
                                        }
                                    }
                                    .font(.title2)

                                    // Cycle right
                                    Button {
                                        if ideasIndex < sessionItemViewModel.generatedIdeas.count - 1 {
                                            ideasIndex += 1
                                        } else {
                                            ideasIndex = 0
                                        }
                                        idea = sessionItemViewModel.generatedIdeas[ideasIndex]
                                    } label: {
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                    }
                                }
                                .frame(minWidth: 20)
                                .padding(10)
                                .background(Color.white)
                                .clipped()
                                .cornerRadius(15)
                                .shadow(color: shadowColor, radius: 4, y: 4)
                            }

                            // AI Word Generation button
                            Button {
                                sessionItemViewModel.clearIdeas()
                                ideasIndex = 0
                                sessionItemViewModel.generateIdeas()
                            } label: {
                                Image("brainwriting")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 90, height: 90)
                                    .padding(.top, 8)
                                    .shadow(color: shadowColor, radius: 4, y: 4)
                            }
                            .padding(.trailing)
                        }
                    }
                }
                Spacer()
            }
        }
        .navigationTitle("Session")
        .navigationBarHidden(true)
        // .edgesIgnoringSafeArea(.all)
    }

}

struct PKCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    let picker = PKToolPicker.init()
    var size: Int = 10000
    var canvasSize: CGSize {
        return CGSize(width: size, height: size)
    }

    var center: CGPoint {
        return CGPoint(x: size/2, y: size/2)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.contentSize = canvasSize
        canvasView.contentOffset = center
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 12)
        canvasView.becomeFirstResponder()
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        picker.addObserver(canvasView)
        picker.setVisible(true, forFirstResponder: canvasView)
        DispatchQueue.main.async {
            canvasView.becomeFirstResponder()
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(showActivity: .constant(true))
            .environmentObject(SessionItemViewModel())
    }
}

// swiftlint:disable large_tuple
// swiftlint:disable identifier_name
// From: https://stackoverflow.com/questions/38435308/get-lighter-and-darker-color-variations-for-a-given-uicolor
extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }
        return (r, g, b, o)
    }

    func lighter(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> Color {
        return Color(red: min(Double(self.components.red + percentage/100), 1.0),
                     green: min(Double(self.components.green + percentage/100), 1.0),
                     blue: min(Double(self.components.blue + percentage/100), 1.0),
                     opacity: Double(self.components.opacity))
    }
}
