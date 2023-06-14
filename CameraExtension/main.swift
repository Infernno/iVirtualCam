//
//  main.swift
//  CameraExtension
//
//  Created by vladislav on 14.06.2023.
//

import Foundation
import CoreMediaIO

let providerSource = CameraExtensionProviderSource(clientQueue: nil)
CMIOExtensionProvider.startService(provider: providerSource.provider)

CFRunLoopRun()
