//
//  MultiValueSlider.swift
//
//  Created by Yonat Sharon on 16/09/2019.
//

#if canImport(SwiftUI)

import SweeterSwift
import SwiftUI

/// Slider clone with multiple thumbs and values, range highlight, optional snap intervals, optional value labels.
@available(iOS 13.0, *) public struct MultiValueSlider: UIViewRepresentable {
    public typealias UIViewType = MultiSlider
    private let uiView = MultiSlider()

    @Binding var value: [CGFloat]

    public init(
        lowerValue: Binding<CGFloat>,
        upperValue: Binding<CGFloat>,
        in bounds: ClosedRange<CGFloat>,
        onEditingEnded: (() -> Void)?
    ) {
        let bindingValue = Binding<[CGFloat]>(
            get: {
                [lowerValue.wrappedValue, upperValue.wrappedValue]
            },
            set: { newValue in
                lowerValue.wrappedValue = newValue[0]
                upperValue.wrappedValue = newValue[1]
            }
        )
        
        self._value = bindingValue
        uiView.minimumValue = bounds.lowerBound
        uiView.maximumValue = bounds.upperBound
        // MARK: default setup
        uiView.hasRoundTrackEnds = true
        uiView.isHapticSnap = true
        uiView.orientation = .horizontal
        uiView.trackWidth = 5
        uiView.onEditingEnded = onEditingEnded
    }

    public func makeUIView(context: UIViewRepresentableContext<MultiValueSlider>) -> MultiSlider {
        uiView.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged), for: .valueChanged)
        return uiView
    }

    public func updateUIView(_ uiView: MultiSlider, context: UIViewRepresentableContext<MultiValueSlider>) {
        uiView.value = value
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject {
        let parent: MultiValueSlider

        init(_ parent: MultiValueSlider) {
            self.parent = parent
        }

        @objc func valueChanged(_ sender: MultiSlider) {
            parent.value = sender.value
        }
    }
}

@available(iOS 13.0, *) public extension MultiValueSlider {
    func minimumValue(_ value: CGFloat) -> Self {
        uiView.minimumValue = value
        return self
    }

    func maximumValue(_ value: CGFloat) -> Self {
        uiView.maximumValue = value
        return self
    }
    
    func step(_ value: CGFloat) -> Self {
        uiView.snapStepSize = value
        uiView.distanceBetweenThumbs = value
        return self
    }

    /// snap thumbs to specific values. changes `minimumValue` and `maximumValue`.  (default = []: allow any value)
    func snapValues(_ value: [CGFloat]) -> Self {
        uiView.snapValues = value
        return self
    }

    /// generate haptic feedback when hitting snap steps
    func isHapticSnap(_ value: Bool) -> Self {
        uiView.isHapticSnap = value
        return self
    }

    /// show value labels next to thumbs
    func valueLabelPosition(_ value: NSLayoutConstraint.Attribute) -> Self {
        uiView.valueLabelPosition = value
        return self
    }

    /// show every other value label opposite of the value label position.
    func valueLabelAlternatePosition(_ value: Bool) -> Self {
        uiView.valueLabelAlternatePosition = value
        return self
    }

    /// value label shows difference from previous thumb value (true) or absolute value (false = default)
    func isValueLabelRelative(_ value: Bool) -> Self {
        uiView.isValueLabelRelative = value
        return self
    }

    // MARK: - Appearance
    func orientation(_ value: NSLayoutConstraint.Axis) -> Self {
        uiView.orientation = value
        return self
    }

    /// track color before first thumb and after last thumb. `nil` means to use the tintColor, like the rest of the track.
    func outerTrackColor(_ value: UIColor?) -> Self {
        uiView.outerTrackColor = value
        return self
    }

    func valueLabelColor(_ value: UIColor?) -> Self {
        uiView.valueLabelColor = value
        return self
    }

    func valueLabelFont(_ value: UIFont?) -> Self {
        uiView.valueLabelFont = value
        return self
    }

    func thumbTintColor(_ value: UIColor?) -> Self {
        uiView.thumbTintColor = value
        return self
    }

    func thumbImage(_ value: UIImage?) -> Self {
        uiView.thumbImage = value
        return self
    }

    func thumbSize(_ value: CGFloat) -> Self {
        uiView.defaultThumbImage = .circle(diameter: value)
        
        return self
    }
    
    func showsThumbImageShadow(_ value: Bool) -> Self {
        uiView.showsThumbImageShadow = value
        return self
    }

    func minimumImage(_ value: UIImage?) -> Self {
        uiView.minimumImage = value
        return self
    }

    func maximumImage(_ value: UIImage?) -> Self {
        uiView.maximumImage = value
        return self
    }

    func snapImage(_ value: UIImage?) -> Self {
        uiView.snapImage = value
        return self
    }

    func trackWidth(_ value: CGFloat) -> Self {
        uiView.trackWidth = value
        return self
    }

    func hasRoundTrackEnds(_ value: Bool) -> Self {
        uiView.hasRoundTrackEnds = value
        return self
    }

    /// when thumb value is minimum or maximum, align it's center with the track end instead of its edge.
    func centerThumbOnTrackEnd(_ value: Bool) -> Self {
        uiView.centerThumbOnTrackEnd = value
        return self
    }

    func keepsDistanceBetweenThumbs(_ value: Bool) -> Self {
        uiView.keepsDistanceBetweenThumbs = value
        return self
    }

    func valueLabelFormatter(_ value: NumberFormatter) -> Self {
        uiView.valueLabelFormatter = value
        return self
    }

    func valueLabelTextForThumb(_ value: ((Int, CGFloat) -> String?)?) -> Self {
        uiView.valueLabelTextForThumb = value
        return self
    }
}

#endif
