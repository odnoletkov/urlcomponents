import Foundation

switch ProcessInfo.processInfo.arguments.count {

case 1:
    fatalError()

case 2:
    let components = URLComponents(string: ProcessInfo.processInfo.arguments[1])!

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

default:
    fatalError("expected zero or one argument")
}
