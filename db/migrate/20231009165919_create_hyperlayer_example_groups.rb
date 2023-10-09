class CreateHyperlayerExampleGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :hyperlayer_example_groups do |t|
      t.string :location
      t.string :description
      t.integer :spec_id
      t.jsonb :data

      t.timestamps
    end
  end
end
