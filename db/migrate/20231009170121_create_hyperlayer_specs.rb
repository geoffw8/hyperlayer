class CreateHyperlayerSpecs < ActiveRecord::Migration[7.0]
  def change
    create_table :hyperlayer_specs do |t|
      t.string :location
      t.string :description
      t.jsonb :data
      t.integer :run_id

      t.timestamps
    end
  end
end
