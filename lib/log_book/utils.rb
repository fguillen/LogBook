module LogBook::Utils
  def self.pretty_changes(model)
    # TODO: this code is duplicated
    clean_changes = model.changes.select { |k,v| !model.log_book_options[:ignore].include? k.to_sym }

    result =
      clean_changes.map do |k,v|
        old_value = v[0]
        new_value = v[1]

        old_value = old_value.to_s( :localdb ) if old_value.instance_of? ActiveSupport::TimeWithZone
        new_value = new_value.to_s( :localdb ) if new_value.instance_of? ActiveSupport::TimeWithZone

        "#{k}[#{old_value} -> #{new_value}]"
      end.join( ", " )

    result
  end
end