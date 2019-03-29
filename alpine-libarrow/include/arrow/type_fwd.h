// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

#ifndef ARROW_TYPE_FWD_H
#define ARROW_TYPE_FWD_H

#include <memory>

#include "arrow/util/visibility.h"

namespace arrow {

class Status;

class DataType;
class Array;
struct ArrayData;
class ArrayBuilder;
class Field;
class Tensor;

class ChunkedArray;
class Column;
class RecordBatch;
class Table;

class Buffer;
class MemoryPool;
class RecordBatch;
class Schema;

class DictionaryType;
class DictionaryArray;

class NullType;
class NullArray;
class NullBuilder;

class BooleanType;
class BooleanArray;
class BooleanBuilder;

class BinaryType;
class BinaryArray;
class BinaryBuilder;

class FixedSizeBinaryType;
class FixedSizeBinaryArray;
class FixedSizeBinaryBuilder;

class StringType;
class StringArray;
class StringBuilder;

class ListType;
class ListArray;
class ListBuilder;

class StructType;
class StructArray;
class StructBuilder;

class Decimal128Type;
class Decimal128Array;
class Decimal128Builder;

class UnionType;
class UnionArray;

template <typename TypeClass>
class NumericArray;

template <typename TypeClass>
class NumericBuilder;

template <typename TypeClass>
class NumericTensor;

#define _NUMERIC_TYPE_DECL(KLASS)                     \
  class KLASS##Type;                                  \
  using KLASS##Array = NumericArray<KLASS##Type>;     \
  using KLASS##Builder = NumericBuilder<KLASS##Type>; \
  using KLASS##Tensor = NumericTensor<KLASS##Type>;

_NUMERIC_TYPE_DECL(Int8);
_NUMERIC_TYPE_DECL(Int16);
_NUMERIC_TYPE_DECL(Int32);
_NUMERIC_TYPE_DECL(Int64);
_NUMERIC_TYPE_DECL(UInt8);
_NUMERIC_TYPE_DECL(UInt16);
_NUMERIC_TYPE_DECL(UInt32);
_NUMERIC_TYPE_DECL(UInt64);
_NUMERIC_TYPE_DECL(HalfFloat);
_NUMERIC_TYPE_DECL(Float);
_NUMERIC_TYPE_DECL(Double);

#undef _NUMERIC_TYPE_DECL

class Date64Type;
using Date64Array = NumericArray<Date64Type>;
using Date64Builder = NumericBuilder<Date64Type>;

class Date32Type;
using Date32Array = NumericArray<Date32Type>;
using Date32Builder = NumericBuilder<Date32Type>;

class Time32Type;
using Time32Array = NumericArray<Time32Type>;
using Time32Builder = NumericBuilder<Time32Type>;

class Time64Type;
using Time64Array = NumericArray<Time64Type>;
using Time64Builder = NumericBuilder<Time64Type>;

class TimestampType;
using TimestampArray = NumericArray<TimestampType>;
using TimestampBuilder = NumericBuilder<TimestampType>;

class IntervalType;
using IntervalArray = NumericArray<IntervalType>;

// ----------------------------------------------------------------------
// (parameter-free) Factory functions
// Other factory functions are in type.h

/// \defgroup type-factories Factory functions for creating data types
///
/// Factory functions for creating data types
/// @{

/// \brief Return a NullType instance
std::shared_ptr<DataType> ARROW_EXPORT null();
/// \brief Return a BooleanType instance
std::shared_ptr<DataType> ARROW_EXPORT boolean();
/// \brief Return a Int8Type instance
std::shared_ptr<DataType> ARROW_EXPORT int8();
/// \brief Return a Int16Type instance
std::shared_ptr<DataType> ARROW_EXPORT int16();
/// \brief Return a Int32Type instance
std::shared_ptr<DataType> ARROW_EXPORT int32();
/// \brief Return a Int64Type instance
std::shared_ptr<DataType> ARROW_EXPORT int64();
/// \brief Return a UInt8Type instance
std::shared_ptr<DataType> ARROW_EXPORT uint8();
/// \brief Return a UInt16Type instance
std::shared_ptr<DataType> ARROW_EXPORT uint16();
/// \brief Return a UInt32Type instance
std::shared_ptr<DataType> ARROW_EXPORT uint32();
/// \brief Return a UInt64Type instance
std::shared_ptr<DataType> ARROW_EXPORT uint64();
/// \brief Return a HalfFloatType instance
std::shared_ptr<DataType> ARROW_EXPORT float16();
/// \brief Return a FloatType instance
std::shared_ptr<DataType> ARROW_EXPORT float32();
/// \brief Return a DoubleType instance
std::shared_ptr<DataType> ARROW_EXPORT float64();
/// \brief Return a StringType instance
std::shared_ptr<DataType> ARROW_EXPORT utf8();
/// \brief Return a BinaryType instance
std::shared_ptr<DataType> ARROW_EXPORT binary();
/// \brief Return a Date32Type instance
std::shared_ptr<DataType> ARROW_EXPORT date32();
/// \brief Return a Date64Type instance
std::shared_ptr<DataType> ARROW_EXPORT date64();

/// @}

}  // namespace arrow

#endif  // ARROW_TYPE_FWD_H
