class TestOne
  include Callable
  expects :path

  def call
    @file = []
    @raw_file = File.readlines(path.path).join

    return @raw_file

    path.events.where(event_type: 'return').each do |event|
      href = "<a href='#'>#{event.method}</a>"

      matches = @raw_file.gsub!(/#{event.method}/, href)
    end

    return @raw_file
      
      
      
      @display_file = @raw_file.map.with_index(1) do |line, index|
      @file << line

      events = path.events.where(event_type: 'return', line_number: index)

      events.map do |event|
        @file << ">>> #{event.return_value.inspect} (#{event.method})"
        @file << "\n"
      end
    end

    @file
  end
end
