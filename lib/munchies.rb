require 'stringio'

module Munchies
  class Logfile

    # Matches timestamps in logfile
    TIME_REGEXP = /^\d{4}-\d{2}-\d{2}T\d{2}\:\d{2}\:\d{2}\b/

    def initialize path, starting_at = nil
      raise ArgumentError unless File.exists?( path )

      @log            = File.open( path )
      @ending_at      = starting_at.nil? ? Time.now : Time.parse( starting_at )
      @starting_at    = (@ending_at - 300)
    end

    def backwards

      filesize      = @log.stat.size
      buffer_size   = 128000
      offset        = buffer_size

      # Seek to the end of the file
      @log.seek(0, File::SEEK_END)

      timestamp     = @starting_at.strftime("%FT%T")

      while @log.tell > 0
        @log.seek(-offset, File::SEEK_END)

        buffer = @log.read( buffer_size )

        # Look at the first two lines of the buffer and check if we are close
        # to the desired timestamp. First line may be incomplete.
        if buffer.split("\n")[0..1].any? { |line| line <= timestamp }

          (1..300).each do |i|

            if index = buffer.index( timestamp )

              # Calculate byte offest and seek to this position
              position = (@log.tell - buffer_size + index)
              @log.seek( position, File::SEEK_SET )
              return
            end

            # If the first timestamp doesn't match count up seconds until it does
            timestamp = (@starting_at + i).strftime("%FT%T")
          end
        end

        offset += buffer_size

        return if offset > filesize
      end

    end

    def emit &block
      backwards

      @log.each_line do |line|
        yield line
      end
    end

  end
end
