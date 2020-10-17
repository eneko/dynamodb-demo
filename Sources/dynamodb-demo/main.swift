import Foundation
import SotoDynamoDB

let arguments = ProcessInfo.processInfo.arguments

if arguments.count == 4, arguments[1] == "set" {
    let key = arguments[2]
    let value = arguments[3]
    try write(key: key, value: value)
    print("\(key)=\(value)")
}
else if arguments.count == 3, arguments[1] == "get" {
    let key = arguments[2]
    let value = try read(key: key)
    print(value ?? "")
}
else {
    print("""
    Usage:
      get <key>             retrieve a value
      set <key> <value>     store a value
    """)
}

struct Entry: Codable {
    let PK: String
    let value: String
}

func write(key: String, value: String) throws {
    let client = AWSClient(credentialProvider: .configFile(credentialsFilePath: "~/.aws/credentials"),
                           httpClientProvider: .createNew)
    defer { try? client.syncShutdown() }

    let dynamoDB = DynamoDB(client: client, region: .uswest1)
    let item = Entry(PK: key, value: value)
    let input = DynamoDB.PutItemCodableInput<Entry>.init(item: item, tableName: "swift-demo")
    _ = try dynamoDB.putItem(input).wait()
}

func read(key: String) throws -> String? {
    let client = AWSClient(credentialProvider: .configFile(credentialsFilePath: "~/.aws/credentials"),
                           httpClientProvider: .createNew)
    defer { try? client.syncShutdown() }

    let dynamoDB = DynamoDB(client: client, region: .uswest1)
    let input = DynamoDB.GetItemInput(key: ["PK": .s(key)], tableName: "swift-demo")
    let result = try dynamoDB.getItem(input, type: Entry.self).wait()
    return result.item?.value
}
