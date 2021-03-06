//
//  JsonLoader.swift
//  Livr
//
//  Created by Felipe Lefèvre Marino on 9/20/18.
//  Copyright © 2018 Felipe Marino. All rights reserved.
//

import Foundation

typealias JSON = [String: Any?]

enum JsonTestFile: String {
    case input, output, rules, errors, aliases
}

struct JsonLoader {
    
    private(set) var directory: String
    
    init(testDirectory: String) {
        self.directory = testDirectory
    }
    
    func load(file: JsonTestFile) -> Any {
        switch file {
        case .aliases:
            let arrayOfJsons: [JSON] = loadJson(for: file.rawValue)
            return arrayOfJsons
        default:
            let json: JSON = loadJson(for: file.rawValue)
            return json
        }
    }
    
    private func loadJson<T>(for file: String) -> T {
        let bundle = Bundle.init(for: PositiveTests.classForCoder())
        guard let fileUrl = bundle.path(forResource: file,
                                        ofType: .json,
                                        inDirectory: directory) else {
                                            
                                            fatalError(.unavailablePathInBundle)
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: fileUrl), options: .alwaysMapped)
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? T else {
                fatalError(.unableToLoadJsonError)
            }

            return json
        } catch {
            fatalError(.unableToLoadJsonError + "\nError: " + error.localizedDescription)
        }
    }
}

// MARK: - Private constants
private extension String {
    static let unavailablePathInBundle = "Could not find file path in bundle"
    static let unableToLoadJsonError = "Could not load json from bundle"
    static let json = "json"
    static let data = "data"
}
