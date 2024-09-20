//
//  NSObject+Storable.swift
//
//
//  Created by h.crane on 2021/04/17.
//

import Combine
import Foundation

// MARK: - Private Property
private var cancellableContext: UInt8 = 0

// MARK: - Private Wrapper Class
private class CancellableWrapper {
    let cancellables: Set<AnyCancellable>
    
    init(cancellables: Set<AnyCancellable>) {
        self.cancellables = cancellables
    }
}

// MARK: - NSObject Extension
public extension NSObject {
    var cancellables: Set<AnyCancellable> {
        get {
            if let wrapper = objc_getAssociatedObject(self, &cancellableContext) as? CancellableWrapper {
                return wrapper.cancellables
            }
            
            let cancellables = Set<AnyCancellable>()
            self.cancellables = cancellables
            return cancellables
        }
        set {
            let wrapper = CancellableWrapper(cancellables: newValue)
            objc_setAssociatedObject(self, &cancellableContext, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
