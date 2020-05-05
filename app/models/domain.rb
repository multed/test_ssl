class Domain < ApplicationRecord
	validates :address, uniqueness: true
end
