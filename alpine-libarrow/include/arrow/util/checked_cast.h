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

#ifndef ARROW_CAST_H
#define ARROW_CAST_H

#include <type_traits>

namespace arrow {
namespace internal {

template <typename OutputType, typename InputType>
inline OutputType checked_cast(InputType&& value) {
  static_assert(std::is_class<typename std::remove_pointer<
                    typename std::remove_reference<InputType>::type>::type>::value,
                "checked_cast input type must be a class");
  static_assert(std::is_class<typename std::remove_pointer<
                    typename std::remove_reference<OutputType>::type>::type>::value,
                "checked_cast output type must be a class");
#ifdef NDEBUG
  return static_cast<OutputType>(value);
#else
  return dynamic_cast<OutputType>(value);
#endif
}

}  // namespace internal
}  // namespace arrow

#endif  // ARROW_CAST_H
