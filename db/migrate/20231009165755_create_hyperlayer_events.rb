class CreateHyperlayerEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :hyperlayer_events do |t|
      t.string :location
      t.string :defined_class
      t.string :event_type
      t.string :method
      t.text :return_value
      t.integer :path_id
      t.integer :line_number
      t.jsonb :spec
      t.integer :example_group_id
      t.jsonb :arguments
      t.jsonb :variables

      t.timestamps
    end
  end
end
