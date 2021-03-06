#!/usr/bin/env swift
import Foundation

var it = CommandLine.arguments.makeIterator()

switch (it.next(), it.next(), it.next()) {

case (_, nil, nil):
    var object = try JSONSerialization.jsonObject(with: FileHandle.standardInput.readDataToEndOfFile()) as! [String: Any]

    if let query = object["query"] as! [String: String?]? {
        var components = URLComponents()
        components.queryItems = query.map(URLQueryItem.init)
        object["query"] = components.query
    }

    let data = try JSONSerialization.data(withJSONObject: object)

    let components = try JSONDecoder().decode(URLComponents.self, from: data)
    guard let string = components.string else {
        fatalError("Invalid URL components: https://developer.apple.com/documentation/foundation/nsurlcomponents/1413469-url")
    }
    
    print(string)

case (_, let path?, nil):
    let components = URLComponents(string: path)!

    var json = try JSONSerialization.jsonObject(with: try JSONEncoder().encode(components)) as! [String: Any]

    json["query"] = components.queryItems.map {
        Dictionary($0.map { ($0.name, $0.value) }) { $1 }
    }

    var options = JSONSerialization.WritingOptions.prettyPrinted
    if #available(OSX 10.13, *) {
        options.formUnion(.sortedKeys)
    }

    let data = try JSONSerialization.data(withJSONObject: json, options: options)
    print(String(data: data, encoding: .utf8)!)

case (_, _, .some):
    fatalError("expected zero or one argument")
}
