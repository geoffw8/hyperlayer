class BuildFileOverlay
  include Callable
  expects :path

  def call
    @file = []
    @raw_file = File.readlines(path.path)

    @display_file = @raw_file.map.with_index(1) do |line, index|
      @file << "#{index}: #{line}"

      events = path.events.where(event_type: 'return', line_number: index)

      events.each do |event|
        item = "      <i style='color: #ccc'>>>> #{event.method} = #{event.return_value.inspect}</i>"

        next if @file.include?(item)

        @file << item
        @file << "\n"
      end
    end

    @file.join
  end
end
