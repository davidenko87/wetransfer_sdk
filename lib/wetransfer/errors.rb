module Wetransfer
  class Errors
    class Error < StandardError; end
    class TransferIOError < StandardError; end
  end
end