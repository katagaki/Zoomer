//
//  ContentView.swift
//  Zoomer
//
//  Created by シン・ジャスティン on 2024/11/10.
//

import SwiftUI


let symbolKeys: [String] = [
    "airplane",
    "ant",
    "bell",
    "bicycle",
    "bolt",
    "bookmark",
    "calendar",
    "camera",
    "cart",
    "cloud",
    "doc",
    "envelope",
    "flag",
    "flame",
    "folder",
    "gift",
    "heart",
    "house",
    "leaf",
    "link",
    "lock",
    "map",
    "mic",
    "moon",
    "paperclip",
    "pencil",
    "phone",
    "star",
    "sun.min",
    "trash",
    "umbrella",
    "wifi",
    "wrench"
]

struct ContentView: View {
    @State var currentMagnification: CGFloat = 1.0
    @State var provisionalMagnification: CGFloat = 0.0
    @State var magnificationAnchor: UnitPoint = .center

    let magnificationLowerLimit = 0.2
    let magnificationUpperLimit = 1.0

    let image: UIImage = UIImage(resource: .sample)
    @State var symbols: [String: UnitPoint] = [:]

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            ZStack(alignment: .topLeading) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: image.size.width, height: image.size.height, alignment: .topLeading)
                ForEach(symbols.keys.sorted(), id: \.self) { key in
                    Image(systemName: key)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color(red: Double.random(in: 0.0..<1.0),
                                               green: Double.random(in: 0.0..<1.0),
                                               blue: Double.random(in: 0.0..<1.0),
                                               opacity: 0.5))
                        .frame(width: 60.0, height: 60.0, alignment: .topLeading)
                        .padding(10.0)
                        .background(.regularMaterial)
                        .overlay {
                            Rectangle()
                                .strokeBorder(.primary, lineWidth: 5.0)
                        }
                        .position(
                            x: CGFloat(symbols[key]?.x ?? 0.0),
                            y: CGFloat(symbols[key]?.y ?? 0.0)
                        )
                        .id(key)
                }
            }
            .scaleEffect(currentMagnification + provisionalMagnification, anchor: magnificationAnchor)
            .frame(
                width: image.size.width * (currentMagnification + provisionalMagnification),
                height: image.size.height * (currentMagnification + provisionalMagnification),
                alignment: .center
            )
        }
        .overlay {
            ZStack(alignment: .topLeading) {
                Color.clear
                VStack(alignment: .leading) {
                    Text("Current Magnification: \(currentMagnification)")
                    Text("Provisional Magnification: \(provisionalMagnification)")
                    Text("Anchor: \(magnificationAnchor)")
                }
            }
        }
        .gesture(
            MagnifyGesture()
                .onChanged { gesture in
                    let originalMagnification = gesture.magnification - 1.0
                    let expectedMagnification = currentMagnification + originalMagnification
                    if expectedMagnification < magnificationLowerLimit {
                        let molassedMagnification = expectedMagnification - magnificationLowerLimit
                        let regularMagnification = originalMagnification - molassedMagnification
                        provisionalMagnification = regularMagnification + (molassedMagnification / 10.0)
                    } else if expectedMagnification > magnificationUpperLimit {
                        let molassedMagnification = expectedMagnification - magnificationUpperLimit
                        let regularMagnification = originalMagnification - molassedMagnification
                        provisionalMagnification = regularMagnification + (molassedMagnification / 10.0)
                    } else {
                        provisionalMagnification = originalMagnification
                    }
                    magnificationAnchor = gesture.startAnchor
                }
                .onEnded { _ in
                    withAnimation(.smooth.speed(2.0)) {
                        let finalMagnificationState = currentMagnification + provisionalMagnification
                        if finalMagnificationState < magnificationLowerLimit {
                            currentMagnification = magnificationLowerLimit
                        } else if finalMagnificationState > magnificationUpperLimit {
                            currentMagnification = magnificationUpperLimit
                        } else {
                            currentMagnification += provisionalMagnification
                        }
                        provisionalMagnification = .zero
                        magnificationAnchor = .center
                    }
                }
        )
        .onAppear {
            for symbolKey in symbolKeys {
                let width = Int(image.size.width)
                let height = Int(image.size.height)
                symbols[symbolKey] = UnitPoint(
                    x: CGFloat(Int.random(in: 90..<(width - 90))),
                    y: CGFloat(Int.random(in: 90..<(height - 90)))
                )
            }
        }
    }
}
