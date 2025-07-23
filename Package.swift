// swift-tools-version:6.0
/*
 * Copyright 2017, gRPC Authors All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import PackageDescription
// swiftformat puts the next import before the tools version.
// swiftformat:disable:next sortImports
import class Foundation.ProcessInfo

let grpcPackageName = "grpc-swift"
let grpcProductName = "GRPC"
let cgrpcZlibProductName = "CGRPCZlib"
let grpcTargetName = grpcProductName
let cgrpcZlibTargetName = cgrpcZlibProductName

let includeNIOSSL = ProcessInfo.processInfo.environment["GRPC_NO_NIO_SSL"] == nil

// MARK: - Package Dependencies

let packageDependencies: [Package.Dependency] = [
  .package(
    url: "https://github.com/apple/swift-nio.git",
    from: "2.65.0"
  ),
  .package(
    url: "https://github.com/apple/swift-nio-http2.git",
    from: "1.36.0"
  ),
  .package(
    url: "https://github.com/apple/swift-nio-transport-services.git",
    from: "1.24.0"
  ),
  .package(
    url: "https://github.com/apple/swift-nio-extras.git",
    from: "1.24.0"
  ),
  .package(
    url: "https://github.com/apple/swift-collections.git",
    from: "1.0.5"
  ),
  .package(
    url: "https://github.com/apple/swift-atomics.git",
    from: "1.2.0"
  ),
  .package(
    url: "https://github.com/apple/swift-protobuf.git",
    from: "1.28.1"
  ),
  .package(
    url: "https://github.com/apple/swift-log.git",
    from: "1.4.4"
  ),
  .package(
    url: "https://github.com/apple/swift-argument-parser.git",
    // Version is higher than in other Package@swift manifests: 1.1.0 raised the minimum Swift
    // version and indluded async support.
    from: "1.1.1"
  ),
].appending(
  .package(
    url: "https://github.com/apple/swift-nio-ssl.git",
    from: "2.23.0"
  ),
  if: includeNIOSSL
)

// MARK: - Target Dependencies

extension Target.Dependency {
  // Target dependencies; external
  nonisolated(unsafe) static let grpc: Self = .target(name: grpcTargetName)
  nonisolated(unsafe) static let cgrpcZlib: Self = .target(name: cgrpcZlibTargetName)
  nonisolated(unsafe) static let protocGenGRPCSwift: Self = .target(name: "protoc-gen-grpc-swift")
  nonisolated(unsafe) static let reflectionService: Self = .target(name: "GRPCReflectionService")

  // Target dependencies; internal
  nonisolated(unsafe) static let grpcSampleData: Self = .target(name: "GRPCSampleData")
  nonisolated(unsafe) static let echoModel: Self = .target(name: "EchoModel")
  nonisolated(unsafe) static let echoImplementation: Self = .target(name: "EchoImplementation")
  nonisolated(unsafe) static let helloWorldModel: Self = .target(name: "HelloWorldModel")
  nonisolated(unsafe) static let routeGuideModel: Self = .target(name: "RouteGuideModel")
  nonisolated(unsafe) static let interopTestModels: Self = .target(name: "GRPCInteroperabilityTestModels")
  nonisolated(unsafe) static let interopTestImplementation: Self =
    .target(name: "GRPCInteroperabilityTestsImplementation")
  nonisolated(unsafe) static let interoperabilityTests: Self = .target(name: "InteroperabilityTests")

  // Product dependencies
  nonisolated(unsafe) static let argumentParser: Self = .product(
    name: "ArgumentParser",
    package: "swift-argument-parser"
  )
  nonisolated(unsafe) static let nio: Self = .product(name: "NIO", package: "swift-nio")
  nonisolated(unsafe) static let nioConcurrencyHelpers: Self = .product(
    name: "NIOConcurrencyHelpers",
    package: "swift-nio"
  )
  nonisolated(unsafe) static let nioCore: Self = .product(name: "NIOCore", package: "swift-nio")
  nonisolated(unsafe) static let nioEmbedded: Self = .product(name: "NIOEmbedded", package: "swift-nio")
  nonisolated(unsafe) static let nioExtras: Self = .product(name: "NIOExtras", package: "swift-nio-extras")
  nonisolated(unsafe) static let nioFoundationCompat: Self = .product(name: "NIOFoundationCompat", package: "swift-nio")
  nonisolated(unsafe) static let nioHTTP1: Self = .product(name: "NIOHTTP1", package: "swift-nio")
  nonisolated(unsafe) static let nioHTTP2: Self = .product(name: "NIOHTTP2", package: "swift-nio-http2")
  nonisolated(unsafe) static let nioPosix: Self = .product(name: "NIOPosix", package: "swift-nio")
  nonisolated(unsafe) static let nioSSL: Self = .product(name: "NIOSSL", package: "swift-nio-ssl")
  nonisolated(unsafe) static let nioTLS: Self = .product(name: "NIOTLS", package: "swift-nio")
  nonisolated(unsafe) static let nioTransportServices: Self = .product(
    name: "NIOTransportServices",
    package: "swift-nio-transport-services"
  )
  nonisolated(unsafe) static let nioTestUtils: Self = .product(name: "NIOTestUtils", package: "swift-nio")
  nonisolated(unsafe) static let nioFileSystem: Self = .product(name: "_NIOFileSystem", package: "swift-nio")
  nonisolated(unsafe) static let logging: Self = .product(name: "Logging", package: "swift-log")
  nonisolated(unsafe) static let protobuf: Self = .product(name: "SwiftProtobuf", package: "swift-protobuf")
  nonisolated(unsafe) static let protobufPluginLibrary: Self = .product(
    name: "SwiftProtobufPluginLibrary",
    package: "swift-protobuf"
  )
  nonisolated(unsafe) static let atomics: Self = .product(name: "Atomics", package: "swift-atomics")
  nonisolated(unsafe) static let dequeModule: Self = .product(name: "DequeModule", package: "swift-collections")
}

// MARK: - Targets

extension Target {
  nonisolated(unsafe) static let grpc: Target = .target(
    name: grpcTargetName,
    dependencies: [
      .cgrpcZlib,
      .nio,
      .nioCore,
      .nioConcurrencyHelpers,
      .nioPosix,
      .nioEmbedded,
      .nioFoundationCompat,
      .nioTLS,
      .nioTransportServices,
      .nioHTTP1,
      .nioHTTP2,
      .nioExtras,
      .logging,
      .protobuf,
      .dequeModule,
      .atomics
    ].appending(
      .nioSSL, if: includeNIOSSL
    ),
    path: "Sources/GRPC"
  )

  nonisolated(unsafe) static let cgrpcZlib: Target = .target(
    name: cgrpcZlibTargetName,
    path: "Sources/CGRPCZlib",
    linkerSettings: [
      .linkedLibrary("z"),
    ]
  )

  nonisolated(unsafe) static let protocGenGRPCSwift: Target = .executableTarget(
    name: "protoc-gen-grpc-swift",
    dependencies: [
      .protobuf,
      .protobufPluginLibrary,
    ],
    exclude: [
      "README.md",
    ]
  )

  nonisolated(unsafe) static let grpcSwiftPlugin: Target = .plugin(
    name: "GRPCSwiftPlugin",
    capability: .buildTool(),
    dependencies: [
      .protocGenGRPCSwift,
    ]
  )

  nonisolated(unsafe) static let grpcTests: Target = .testTarget(
    name: "GRPCTests",
    dependencies: [
      .grpc,
      .echoModel,
      .echoImplementation,
      .helloWorldModel,
      .interopTestModels,
      .interopTestImplementation,
      .grpcSampleData,
      .nioCore,
      .nioConcurrencyHelpers,
      .nioPosix,
      .nioTLS,
      .nioHTTP1,
      .nioHTTP2,
      .nioEmbedded,
      .nioTransportServices,
      .logging,
      .reflectionService,
      .atomics
    ].appending(
      .nioSSL, if: includeNIOSSL
    ),
    exclude: [
      "Codegen/Serialization/echo.grpc.reflection"
    ]
  )

  nonisolated(unsafe) static let interopTestModels: Target = .target(
    name: "GRPCInteroperabilityTestModels",
    dependencies: [
      .grpc,
      .nio,
      .protobuf,
    ],
    exclude: [
      "README.md",
      "generate.sh",
      "src/proto/grpc/testing/empty.proto",
      "src/proto/grpc/testing/empty_service.proto",
      "src/proto/grpc/testing/messages.proto",
      "src/proto/grpc/testing/test.proto",
      "unimplemented_call.patch",
    ]
  )

  nonisolated(unsafe) static let interopTestImplementation: Target = .target(
    name: "GRPCInteroperabilityTestsImplementation",
    dependencies: [
      .grpc,
      .interopTestModels,
      .nioCore,
      .nioPosix,
      .nioHTTP1,
      .logging,
    ].appending(
      .nioSSL, if: includeNIOSSL
    )
  )

  nonisolated(unsafe) static let interopTests: Target = .executableTarget(
    name: "GRPCInteroperabilityTests",
    dependencies: [
      .grpc,
      .interopTestImplementation,
      .nioCore,
      .nioPosix,
      .logging,
      .argumentParser,
    ]
  )

  nonisolated(unsafe) static let backoffInteropTest: Target = .executableTarget(
    name: "GRPCConnectionBackoffInteropTest",
    dependencies: [
      .grpc,
      .interopTestModels,
      .nioCore,
      .nioPosix,
      .logging,
      .argumentParser,
    ],
    exclude: [
      "README.md",
    ]
  )

  nonisolated(unsafe) static let perfTests: Target = .executableTarget(
    name: "GRPCPerformanceTests",
    dependencies: [
      .grpc,
      .grpcSampleData,
      .nioCore,
      .nioEmbedded,
      .nioPosix,
      .nioHTTP2,
      .argumentParser,
    ]
  )

  nonisolated(unsafe) static let grpcSampleData: Target = .target(
    name: "GRPCSampleData",
    dependencies: includeNIOSSL ? [.nioSSL] : [],
    exclude: [
      "bundle.p12",
    ]
  )

  nonisolated(unsafe) static let echoModel: Target = .target(
    name: "EchoModel",
    dependencies: [
      .grpc,
      .nio,
      .protobuf,
    ],
    path: "Examples/v1/Echo/Model"
  )

  nonisolated(unsafe) static let echoImplementation: Target = .target(
    name: "EchoImplementation",
    dependencies: [
      .echoModel,
      .grpc,
      .nioCore,
      .nioHTTP2,
      .protobuf,
    ],
    path: "Examples/v1/Echo/Implementation"
  )

  nonisolated(unsafe) static let echo: Target = .executableTarget(
    name: "Echo",
    dependencies: [
      .grpc,
      .echoModel,
      .echoImplementation,
      .grpcSampleData,
      .nioCore,
      .nioPosix,
      .logging,
      .argumentParser,
    ].appending(
      .nioSSL, if: includeNIOSSL
    ),
    path: "Examples/v1/Echo/Runtime"
  )

  nonisolated(unsafe) static let helloWorldModel: Target = .target(
    name: "HelloWorldModel",
    dependencies: [
      .grpc,
      .nio,
      .protobuf,
    ],
    path: "Examples/v1/HelloWorld/Model"
  )

  nonisolated(unsafe) static let helloWorldClient: Target = .executableTarget(
    name: "HelloWorldClient",
    dependencies: [
      .grpc,
      .helloWorldModel,
      .nioCore,
      .nioPosix,
      .argumentParser,
    ],
    path: "Examples/v1/HelloWorld/Client"
  )

  nonisolated(unsafe) static let helloWorldServer: Target = .executableTarget(
    name: "HelloWorldServer",
    dependencies: [
      .grpc,
      .helloWorldModel,
      .nioCore,
      .nioPosix,
      .argumentParser,
    ],
    path: "Examples/v1/HelloWorld/Server"
  )

  nonisolated(unsafe) static let routeGuideModel: Target = .target(
    name: "RouteGuideModel",
    dependencies: [
      .grpc,
      .nio,
      .protobuf,
    ],
    path: "Examples/v1/RouteGuide/Model"
  )

  nonisolated(unsafe) static let routeGuideClient: Target = .executableTarget(
    name: "RouteGuideClient",
    dependencies: [
      .grpc,
      .routeGuideModel,
      .nioCore,
      .nioPosix,
      .argumentParser,
    ],
    path: "Examples/v1/RouteGuide/Client"
  )

  nonisolated(unsafe) static let routeGuideServer: Target = .executableTarget(
    name: "RouteGuideServer",
    dependencies: [
      .grpc,
      .routeGuideModel,
      .nioCore,
      .nioConcurrencyHelpers,
      .nioPosix,
      .argumentParser,
    ],
    path: "Examples/v1/RouteGuide/Server"
  )

  nonisolated(unsafe) static let packetCapture: Target = .executableTarget(
    name: "PacketCapture",
    dependencies: [
      .grpc,
      .echoModel,
      .nioCore,
      .nioPosix,
      .nioExtras,
      .argumentParser,
    ],
    path: "Examples/v1/PacketCapture",
    exclude: [
      "README.md",
    ]
  )

  nonisolated(unsafe) static let reflectionService: Target = .target(
    name: "GRPCReflectionService",
    dependencies: [
      .grpc,
      .nio,
      .protobuf,
    ],
    path: "Sources/GRPCReflectionService"
  )

  nonisolated(unsafe) static let reflectionServer: Target = .executableTarget(
    name: "ReflectionServer",
    dependencies: [
      .grpc,
      .reflectionService,
      .helloWorldModel,
      .nioCore,
      .nioPosix,
      .argumentParser,
      .echoModel,
      .echoImplementation
    ],
    path: "Examples/v1/ReflectionService",
    resources: [
      .copy("Generated")
    ]
  )
}

// MARK: - Products

extension Product {
  nonisolated(unsafe) static let grpc: Product = .library(
    name: grpcProductName,
    targets: [grpcTargetName]
  )

  nonisolated(unsafe) static let cgrpcZlib: Product = .library(
    name: cgrpcZlibProductName,
    targets: [cgrpcZlibTargetName]
  )

  nonisolated(unsafe) static let grpcReflectionService: Product = .library(
    name: "GRPCReflectionService",
    targets: ["GRPCReflectionService"]
  )

  nonisolated(unsafe) static let protocGenGRPCSwift: Product = .executable(
    name: "protoc-gen-grpc-swift",
    targets: ["protoc-gen-grpc-swift"]
  )

  nonisolated(unsafe) static let grpcSwiftPlugin: Product = .plugin(
    name: "GRPCSwiftPlugin",
    targets: ["GRPCSwiftPlugin"]
  )
}

// MARK: - Package

let package = Package(
  name: grpcPackageName,
  products: [
    .grpc,
    .cgrpcZlib,
    .grpcReflectionService,
    .protocGenGRPCSwift,
    .grpcSwiftPlugin,
  ],
  dependencies: packageDependencies,
  targets: [
    // Products
    .grpc,
    .cgrpcZlib,
    .protocGenGRPCSwift,
    .grpcSwiftPlugin,
    .reflectionService,

    // Tests etc.
    .grpcTests,
    .interopTestModels,
    .interopTestImplementation,
    .interopTests,
    .backoffInteropTest,
    .perfTests,
    .grpcSampleData,

    // Examples
    .echoModel,
    .echoImplementation,
    .echo,
    .helloWorldModel,
    .helloWorldClient,
    .helloWorldServer,
    .routeGuideModel,
    .routeGuideClient,
    .routeGuideServer,
    .packetCapture,
    .reflectionServer,
  ]
)

extension Array {
  func appending(_ element: Element, if condition: Bool) -> [Element] {
    if condition {
      return self + [element]
    } else {
      return self
    }
  }
}
