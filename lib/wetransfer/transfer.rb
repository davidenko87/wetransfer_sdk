module Wetransfer
  class Transfer

    def initialize(message:, files: [])
      @message = message
      @files = files
    end

    def add_file(name:, io:)
      ensure_io_compliant!(io)
      @files << file_request_params(name: name, io: io)
    end

    def request_params
      {
        message: @message,
        files: @files
      }
    end

    def file_request_params(name:, io:)
      {
        name: name,
        size: io.size,
      }
    end

    def ensure_io_compliant!(io)
      io.seek(0)
      io.read(1) # Will cause things like Errno::EACCESS to happen early, before the upload begins
      io.seek(0) # Also rewinds the IO for later uploading action
      size = io.size # Will cause a NoMethodError
      raise Wetransfer::Errors::TransferIOError, 'The IO object given to add_file has a size of 0' if size <= 0
    rescue NoMethodError
      raise Wetransfer::Errors::TransferIOError, "The IO object given to add_file must respond to seek(), read() and size(), but #{io.inspect} did not"
    end
  end
end
