puts "Loading LogBook::Utils"
module LogBook::Utils
  def self.pretty_changes(model)
    # TODO: this line of code is duplicated
    if ActiveRecord::VERSION::STRING.to_f >= 5.1
      clean_changes = model.saved_changes.select { |k,v| !model.log_book_options[:ignore].include? k.to_sym }
    else
      clean_changes = model.changes.select { |k,v| !model.log_book_options[:ignore].include? k.to_sym }
    end

    result =
      clean_changes.map do |k,v|
        old_value = v[0]
        new_value = v[1]

        old_value = old_value.utc.strftime("%Y-%m-%d %H:%M:%S") if old_value.is_a? Time
        new_value = new_value.utc.strftime("%Y-%m-%d %H:%M:%S") if new_value.is_a? Time

        {
          "key" => k,
          "before" => old_value,
          "after" => new_value
        }
      end

    result
  end
end
