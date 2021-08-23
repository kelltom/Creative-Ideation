//
//  BannerModifier.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-08-23.
//
//  References
//      - https://jboullianne.medium.com/notification-banner-using-swiftui-d7d3cd2fa24b
//      - https://prafullkumar77.medium.com/swiftui-how-to-make-toast-and-notification-banners-bc8aae313b33

import SwiftUI

struct BannerModifier: ViewModifier {

    struct BannerData {
        var title: String
        var detail: String
        var type: BannerType
    }

    enum BannerType {
        case info
        case warning
        case success
        case error

        var tintColor: Color {
            switch self {
            case .info:
                return .blue
            case .success:
               return .green
            case .warning:
               return .yellow
            case .error:
               return .red
            }
        }

        var sfSymbol: String {
            switch self {
            case .info:
                return "info.circle"
            case .success:
                return "checkmark.seal"
            case .warning:
                return "exclamationmark.octagon"
            case .error:
                return "xmark.octagon"
            }
        }
    }

    @Binding var data: BannerData
    @Binding var show: Bool

    func body(content: Content) -> some View {
        // ZStack to overlay on top of content
        ZStack {
            if show {
                VStack {
                    // HStack to fill width of screen
                    HStack {
                        // Banner content here
                        Image.init(systemName: data.type.sfSymbol)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data.title)
                                .bold()
                            Text(data.detail)
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                        }
                        .foregroundColor(Color.white)
                        .padding(12)
                        .background(data.type.tintColor)
                        .cornerRadius(8)
                    }
                    Spacer()
                }
            }
            content
        }
    }
}

extension View {
    func banner(data: Binding<BannerModifier.BannerData>, show: Binding<Bool>) -> some View {
        self.modifier(BannerModifier(data: data, show: show))
    }
}
