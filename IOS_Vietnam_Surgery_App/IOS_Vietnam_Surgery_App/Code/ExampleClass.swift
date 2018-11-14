//
//  ExampleClass.swift
//  IOS_Vietnam_Surgery_App
//
//  Created by Ravi on 14/11/2018.
//  Copyright © 2018 Matermind. All rights reserved.
//

import Foundation

private class ExampleClass
{
    // for field we use this example
    private var exampleField : Int?
    
    // for constants we use this example
    public static let exampleConstant = 0
 
    // for a property we use
    public var exampleProperty : Int? {
        get {
            return self.exampleField
        }
        set(exampleField) {
            self.exampleField = exampleField
        }
    }
    
    // for the initializer we use this example.
    init(exampleField : Int?) {
        self.exampleField = exampleField
    }
    
    // for public function we use this example
    public func examplePublicFunction(exampleField : Int?) {
        if let exampleField = self.exampleField {
            print(exampleField)
        }
    }
    
    // for private function we use this example
    private func examplePrivateFunction(exampleField : Int?) {
        guard let exampleField = self.exampleField else { return }
        print(exampleField)
    }
    
}
