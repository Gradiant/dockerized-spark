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

// Buffered stream implementations

#ifndef ARROW_IO_BUFFERED_H
#define ARROW_IO_BUFFERED_H

#include <cstdint>
#include <memory>

#include "arrow/io/interfaces.h"
#include "arrow/util/string_view.h"
#include "arrow/util/visibility.h"

namespace arrow {

class Buffer;
class MemoryPool;
class Status;

namespace io {

class ARROW_EXPORT BufferedOutputStream : public OutputStream {
 public:
  ~BufferedOutputStream() override;

  /// \brief Create a buffered output stream wrapping the given output stream.
  /// \param[in] buffer_size the size of the temporary write buffer
  /// \param[in] pool a MemoryPool to use for allocations
  /// \param[in] raw another OutputStream
  /// \param[out] out the created BufferedOutputStream
  /// \return Status
  static Status Create(int64_t buffer_size, MemoryPool* pool,
                       std::shared_ptr<OutputStream> raw,
                       std::shared_ptr<BufferedOutputStream>* out);

  /// \brief Resize internal buffer
  /// \param[in] new_buffer_size the new buffer size
  /// \return Status
  Status SetBufferSize(int64_t new_buffer_size);

  /// \brief Return the current size of the internal buffer
  int64_t buffer_size() const;

  /// \brief Flush any buffered writes and release the raw
  /// OutputStream. Further operations on this object are invalid
  /// \param[out] raw the underlying OutputStream
  /// \return Status
  Status Detach(std::shared_ptr<OutputStream>* raw);

  // OutputStream interface

  /// \brief Close the buffered output stream.  This implicitly closes the
  /// underlying raw output stream.
  Status Close() override;
  bool closed() const override;

  Status Tell(int64_t* position) const override;
  // Write bytes to the stream. Thread-safe
  Status Write(const void* data, int64_t nbytes) override;

  Status Flush() override;

  /// \brief Return the underlying raw output stream.
  std::shared_ptr<OutputStream> raw() const;

 private:
  explicit BufferedOutputStream(std::shared_ptr<OutputStream> raw, MemoryPool* pool);

  class ARROW_NO_EXPORT Impl;
  std::unique_ptr<Impl> impl_;
};

/// \class BufferedInputStream
/// \brief An InputStream that performs buffered reads from an unbuffered
/// InputStream, which can mitigate the overhead of many small reads in some
/// cases
class ARROW_EXPORT BufferedInputStream : public InputStream {
 public:
  ~BufferedInputStream() override;

  /// \brief Create a BufferedInputStream from a raw InputStream
  /// \param[in] buffer_size the size of the temporary read buffer
  /// \param[in] pool a MemoryPool to use for allocations
  /// \param[in] raw a raw InputStream
  /// \param[out] out the created BufferedInputStream
  static Status Create(int64_t buffer_size, MemoryPool* pool,
                       std::shared_ptr<InputStream> raw,
                       std::shared_ptr<BufferedInputStream>* out);

  /// \brief Resize internal read buffer; calls to Read(...) will read at least
  /// \param[in] new_buffer_size the new read buffer size
  /// \return Status
  Status SetBufferSize(int64_t new_buffer_size);

  /// \brief Return the number of remaining bytes in the read buffer
  int64_t bytes_buffered() const;

  /// \brief Return the current size of the internal buffer
  int64_t buffer_size() const;

  /// \brief Release the raw InputStream. Any data buffered will be
  /// discarded. Further operations on this object are invalid
  /// \return raw the underlying InputStream
  std::shared_ptr<InputStream> Detach();

  /// \brief Return the unbuffered InputStream
  std::shared_ptr<InputStream> raw() const;

  // InputStream APIs
  util::string_view Peek(int64_t nbytes) const override;
  Status Close() override;
  bool closed() const override;

  /// \brief Returns the position of the buffered stream, though the position
  /// of the unbuffered stream may be further advanced
  Status Tell(int64_t* position) const override;

  Status Read(int64_t nbytes, int64_t* bytes_read, void* out) override;

  /// \brief Read into buffer. If the read is already buffered, then this will
  /// return a slice into the buffer
  Status Read(int64_t nbytes, std::shared_ptr<Buffer>* out) override;

 private:
  explicit BufferedInputStream(std::shared_ptr<InputStream> raw, MemoryPool* pool);

  class ARROW_NO_EXPORT Impl;
  std::unique_ptr<Impl> impl_;
};

}  // namespace io
}  // namespace arrow

#endif  // ARROW_IO_BUFFERED_H
