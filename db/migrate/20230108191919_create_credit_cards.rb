# frozen_string_literal: true

class CreateCreditCards < ActiveRecord::Migration[7.0]
  def change
    create_table :credit_cards do |t|
      t.references :account, null: false, foreign_key: true
      t.string  :pan, null: false
      t.string  :holder, null: false
      t.integer  :exp_month, null: false
      t.integer  :exp_year, null: false

      t.timestamps
    end

    add_index :credit_cards, %i[account_id pan], unique: true
  end
end
