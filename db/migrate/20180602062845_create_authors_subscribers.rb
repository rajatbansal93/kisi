class CreateAuthorsSubscribers < ActiveRecord::Migration[5.2]
  def change
    create_table :authors_subscribers do |t|
      t.references :author, index: true
      t.references :subscriber, index: true
    end
  end
end
