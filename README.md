[![Tested on GitHub Actions](https://github.com/RougeWare/swift-SerializationTools/actions/workflows/swift.yml/badge.svg)](https://github.com/RougeWare/Swift-SerializationTools/actions/workflows/swift.yml) [![Codefactor checked](https://www.codefactor.io/repository/github/rougeware/swift-SerializationTools/badge)](https://www.codefactor.io/repository/github/rougeware/swift-SerializationTools)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FRougeWare%2FSwift-SerializationTools%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/RougeWare/Swift-SerializationTools) [![swift package manager 5.3 is supported](https://img.shields.io/badge/swift%20package%20manager-5.3-brightgreen.svg)](https://github.com/RougeWare/Swift-SerializationTools/blob/production/Package.swift) [![Supports macOS, iOS, tvOS, watchOS, Linux, & Windows](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FRougeWare%2FSwift-SerializationTools%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/RougeWare/Swift-SerializationTools) 
[![](https://img.shields.io/github/release-date/rougeware/swift-serializationtools?label=latest%20release)](https://github.com/RougeWare/Swift-SerializationTools/releases/latest)



# [Swift `SerializationTools`](https://github.com/RougeWare/Swift-SerializationTools) #

Some tools to help y'all serialize stuff



## JSON conveniences

Swift's JSON encoding & decoding is really good! ... but the API could use a bit of sugar.

This package brings that sweetness!

```swift

// Let's start this example with a simple struct.
// It's got a little bit going on: there's two fields, each a different type, and one is `Optional`.
//
// Its Codable conformance is synthesized from its fields all being Codable.
// I'm also making it `Equatable` so we can make sure things work properly 

struct NamedCount: Codable, Equatable {
    let name: String
    let count: UInt?
}



// Now let's make some instances to work with

let bananaCount = NamedCount(name: "Bananas", count: 7)
let tomorrowEventSecondsCount = NamedCount(name: "Number of Seconds In Tomorrow's Event", count: nil)



// With those made, what's it look like to serialize them?
// Well, before this package, you'd have to make a JSONEncoder object, then configure it, then use it, then.... dispose
// of it I guess? Kinda feels like Objective-C, doesn't it? (Swiftjective-C?)
//
// With this package, it's as simple as calling `.jsonString()`!
// You can even pass configuration to it as parameters! Very Swift-y

// `.jsonString()` creates a UTF-8 JSON string
let bananaCountJsonString = try bananaCount.jsonString()
// {"name":"Bananas","count":7}

// `.jsonData()` creates a UTF-8-encoded JSON string as raw `Data`
let tomorrowEventSecondsCountJsonData = try tomorrowEventSecondsCount.jsonData()
// Essentially {"name":"Number of Seconds In Tomorrow's Event"}



// Well that was easy! But what about decoding?
// That, too, is similarly natural and Swift-y:

let decodedBananaCount = try NamedCount(jsonString: bananaCountJsonString)
let decodedTomorrowEventSecondsCount = try NamedCount(jsonData: tomorrowEventSecondsCountJsonData)


// It's like JSON is a first-class citizen!
// And of course the decoded values are just the same as before they were encoded:

assert(decodedBananaCount == bananaCount)
assert(decodedTomorrowEventSecondsCount == tomorrowEventSecondsCount)



// And of course you can use literals with this too:

let countOfRoadsOneCanWalkDown = try NamedCount(jsonString: """
{
    "name": "How many roads can one walk down?",
    "count": 42
}
""")
```



## Codable Bridge

`Codable` is the Swift re-imagining of `NSCoding`. I think we all can agree that `Codable` is much better!

But, some things (especially in Apple frameworks) conform to `NSCoding` but not `Codable`! What is one to do?

Well, never fear! A solution[\*](#Codable-bridge-disclaimer) is here!

```swift
// Probably the most common way that I run into this is with AppKit and UIKit, so let's use those as examples!

struct User: Codable, Equatable {
    let name: String
    let avatar: UIImage.CodableBridge?
    let favoriteColor: UIColor.CodableBridge
}


// I'll only use one instance this time, because I think it's enough to get the point across.
// Here's Redd. He likes the color red!
//
// Here we see the concession to the API user: they have to use `.codable` to create the codable bridge.
// I recommend making a sugary initializer which just takes the base type, like
// `init(name: String, avatar: UIImage, favoriteColor: UIColor)`

let redd = User(
    name: "Redd",
    avatar: UIImage(named: "Redd-avatar").codable,
    favoriteColor: UIColor(hue: 0.111, saturation: 0.78, brightness:  0.96, alpha: 1).codable
)


// And I'm sure you expect this, but that struct needs nothing more special to be able to encode &and decode it!

let reddJsonString = try redd.jsonString()
// Essentially {"name":"Redd","avatar":"<insert Base64 nonsense here>","favoriteColor":"<insert Base64 nonsense here>"}


let decodedRedd = try Redd(jsonString: reddJsonString)


// And of course the decoded value is just the same as before it was encoded, just like any native `Codable` type:

assert(decodedRedd == redd)


// The other caveat is that accessing the base type's methods is a bit indirect as well:

redd.favoriteColor.value.set()


// But at least accessing fields is straightforawrd thanks to `@dynamicMemberLookup`:

print(redd.avatar.size)
```



> <a id="Codable-bridge-disclaimer"></a>\* Due to the limitations of Swift's approach to reference type initializers, a true `Codable` implementation can't be synthesized on all `NSCoding` types without risking a crash for invalid data. As such, I've decided to make a synthesized subtype of all `NSCoding` types, which can be as easily (en/de)coded. I tried to make this as ergonomic as possible; [let me know if you have any better ideas!](https://github.com/RougeWare/Swift-SerializationTools/issues/new/choose)
