class CreateJobStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :job_statuses do |t|
      t.string :job_id
      t.string :status
      t.jsonb :result, default: {}

      t.timestamps
    end

    add_index :job_statuses, :job_id, unique: true
  end
end
