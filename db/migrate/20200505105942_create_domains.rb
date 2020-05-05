class CreateDomains < ActiveRecord::Migration[6.0]
  def change
    create_table :domains do |t|
      t.string  :address
      t.bool :status
      t.text :desc

      t.timestamps
    end
  end
end
