//
//  TrackerScheduleValueTransformer.swift
//  Tracker
//
//  Created by 1111 on 10.03.2025.
//

import Foundation

@objc
final class TrackerScheduleValueTransformer: ValueTransformer {
    private let decoder: JSONDecoder = JSONDecoder()
    private let encoder: JSONEncoder = JSONEncoder()
    
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let trackers = value as? [Int] else { return nil }
        return try? encoder.encode(trackers)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? decoder.decode([Int].self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            TrackerScheduleValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: TrackerScheduleValueTransformer.self))
        )
    }
}
