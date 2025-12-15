//
// SPDX-License-Identifier: Apache-2.0
//
// Copyright 2025 Mattias Holm
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

public enum DBFError: Error {
  case invalidHeaderDate(String)
  case invalidDate(String)
  case unsupportedColumnType(String)
  case invalidFieldLength(Int)
  case invalidConstrainedFieldLength(DBF.ColumnType, Int)
  case unexpectedRecordTag(Int)
  case invalidFieldContent(DBF.ColumnType, String)
}

extension String {
  func trimNullAndWS() -> String {
    self.replacingOccurrences(of: "\0", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

public struct DBF {
  public enum ColumnType : Character, Sendable {
    case STRING = "C"
    case NUMERIC = "N"
    case DATE = "D"
    case LOGICAL = "L"
    case FLOAT = "F"
    case MEMO = "M"
  }

  public struct Header {
    public var dbfVersion: UInt8 = 0x03
    public var lastUpdate: Date = Date.now
    public var numRecords: Int = 0
    public var headerLength: Int = 0
    public var recordLength: Int = 0
    public var incompleteTransaction: Bool = false
    public var isEncrypted: Bool = false
    public var productionMDX: Bool = false
    public var languageDriver: UInt8 = 0
  }

  public struct FieldDescriptor {
    public let name: String
    public let columnType: ColumnType
    public let length: Int
    public let decimalCount: Int
    public let workAreaID: Int
    public let production: Bool
  }

  public enum RecordValue: Equatable {
    case string(String)
    case int(Int)
    case double(Double)
    case date(Date)
    case logical(Bool)
    case null
  }

  public struct Record {
    public let deleted: Bool
    public var values: [RecordValue] = []
  }

  public var header: Header
  public var fields: [FieldDescriptor] = []
  public var records: [Record] = []
}
