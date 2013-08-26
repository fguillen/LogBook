module LogBook::Utils
  def self.pretty_changes(model)
    result =
      model.changes.reject { |k,v| k == "updated_at" || k =~ /password/ || k == "perishable_token" || k == "persistence_token" }.map do |k,v|
        old_value = v[0]
        new_value = v[1]

        old_value = old_value.to_s( :localdb ) if old_value.instance_of? ActiveSupport::TimeWithZone
        new_value = new_value.to_s( :localdb ) if new_value.instance_of? ActiveSupport::TimeWithZone

        "#{k}[#{old_value} -> #{new_value}]"
      end.join( ", " )

    result
  end
end