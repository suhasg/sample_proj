class UsersController < ApplicationController


  def index
    User.create(first_name: "Suhas #{rand(100)}", last_name: "G", dob: Time.now, phone: "+919900942942", age: 28)
  end

end
