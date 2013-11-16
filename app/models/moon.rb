class Moon < ActiveRecord::Base
  #t.string :name
  #t.integer :size

  has_one :planet
end
