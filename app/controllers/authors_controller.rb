require 'bcrypt'
include ActionController::Cookies

class AuthorsController < ApplicationController
  before_action :set_author, only: %i[ show update destroy ]

  

  # POST /login
  def login
    if request.method == "GET" && cookies['auth_token'] && cookies['auth_token'].length > 0
      return render json: Author.get_auth_token(cookies['auth_token'])[0]
    end
    @author = Author.find_by(:email => params[:email])
    if @author.nil?
      return render json: {:error => "There is no matching user with this email."}, status: :not_found
    end
    if BCrypt::Password.new(@author.password) != params[:password]
      return render json: { error:"Invalid password" }, status: :forbidden
    end
    authorize()
    render json: @author.attributes.except("password")
  end

  # GET /logout
  def logout
    cookies['auth_token'] =  { 
      value: "",
      httponly: true
    }
    render json: { message: "Logged out" }
  end

  # POST /authors
  def create
    new_params = author_params()
    @author = Author.new(new_params)
    if @author.validate
      new_params[:password] = BCrypt::Password.create(params[:password], :cost => 8)
      @author = Author.new(new_params)
    end
    if @author.save!
      authorize()
      render json: @author, status: :created, location: @author
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  private
    def authorize
      auth_token =  Author.set_auth_token(@author.attributes.except("password"))
      cookies['auth_token'] =  { 
        value: auth_token, 
        httponly: true,
        expires: 60.minutes.from_now,
      }
    end

    def author_params
      params.require(:author).permit(:first_name, :last_name, :email, :password)
    end
end
