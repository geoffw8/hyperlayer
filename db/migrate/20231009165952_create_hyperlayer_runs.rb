class CreateHyperlayerRuns < ActiveRecord::Migration[7.0]
  def change
    create_table :hyperlayer_runs do |t|
      t.integer :process

      t.timestamps
    end
  end
end
