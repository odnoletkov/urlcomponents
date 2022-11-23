#!/usr/bin/env swift
import Foundation

var it = CommandLine.arguments.makeIterator()

switch (it.next(), it.next(), it.next()) {

case (_, nil, nil):
    var object = try JSONSerialization.jsonObject(with: FileHandle.standardInput.readDataToEndOfFile()) as! [String: Any]
    let query = object["query"]
    object["query"] = nil

    let data = try JSONSerialization.data(withJSONObject: object)
    var components = try JSONDecoder().decode(URLComponents.self, from: data)

    if let query = query as! [String: String?]? {
        components.queryItems = query.map(URLQueryItem.init(name:value:))
    }

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
