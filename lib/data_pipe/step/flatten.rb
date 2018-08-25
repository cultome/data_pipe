
module DataPipe::Step
  class Flatten
    include DataPipe::Stepable

    def step_command
      :flatten
    end

    def process(record)
      flat_record = flat_hash record.data
      Record.new(flat_record, OpenStruct.new(headers: true))
    end

    private

    def flat_hash(data)
      flattened = {}
      changed = false

      data.keys.each do |key|
        if data[key].is_a? Hash
          data[key].keys.each do |nest_key|
            flattened["#{key}.#{nest_key}"] = data[key][nest_key]
          end

          changed = true

        elsif data[key].is_a? Array
          flattened[key] = data[key].join("|")

        else
          flattened[key] = data[key]
        end
      end

      return flat_hash(flattened) if changed
      flattened
    end
  end
end

