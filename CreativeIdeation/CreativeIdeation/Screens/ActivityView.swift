//
//  ActivityView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-27.
//

import SwiftUI
import PencilKit

struct ActivityView: View {

    @State private var canvasView = PKCanvasView()
    @Binding var showActivity: Bool

    var body: some View {
        ZStack {
            // Whatever view we use for the canvas will be placed here,
            // so that all other elements are placed above it on the zstack
            PKCanvas(canvasView: $canvasView)

            StickyNote()

            StickyNote()


//            var simpleDrag: some Gesture {
//                DragGesture()
//                    .onChanged{ value in
//                        self.location = value.location}
//            }
//            ScrollView([.horizontal, .vertical]) {
//                StickyNote()
//                StickyNote()
//            }
//            .frame(width: 10000, height: 10000)


            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        // Hi
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 100)
                            .background(Color.red)
                            .cornerRadius(18)
                    }
                }
            }

            HStack {
                ActivityToolbar()
                Spacer()
                VStack {
                    ActiveMembers()
                    Spacer()
                }
            }
            .hidden()
        }
        .edgesIgnoringSafeArea(.all)
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

struct StickyNote: View {
    @State private var location: CGPoint = CGPoint(x: 50, y: 50)
    @GestureState private var fingerLocation: CGPoint? = nil
    // var title: String = ""
    // @Binding var input: String

    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .foregroundColor(.red)
            .frame(width: 100, height: 100)
            .position(location)
            .gesture(simpleDrag)
    }

    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.location = value.location }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(showActivity: .constant(true))
    }
}
