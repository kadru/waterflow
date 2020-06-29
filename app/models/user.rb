# frozen_string_literal: true

# User model
class User < ApplicationRecord
  include Clearance::User
end
