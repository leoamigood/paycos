# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      create_sequence :transaction_id_seq, start: 1, increment: 1

      t.bigint :transaction_id, null: false, default: -> { "nextval('transaction_id_seq')" }
      t.references :account, null: false, index: true, foreign_key: true
      t.references :credit_card, null: false, foreign_key: true
      t.integer :amount, null: false
      t.string  :description

      t.timestamps
    end
  end
end
