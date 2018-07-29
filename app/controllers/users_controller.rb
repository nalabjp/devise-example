class UsersController < ApplicationController
  def index
    @users = User.all.to_a
  end
end
