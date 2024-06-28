class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        element = find_by_email() #on retrouver l'utilisateur créer par l'email qui est unique
        if params[:user][:buyer] == "1" #S'il y a dit qu'il est acheteur on l'ajoute dans la table buyer
          Buyer.new({:user_id => element[:id]}).save()
        end
        if params[:user][:seller] == "1" #S'il y a dit qu'il est vendeur on l'ajoute dans la table seller
          Seller.new({:user_id => element[:id]}).save()
        end
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update

    respond_to do |format|
      if @user.update(user_params)
        
        #si la sauvegarde c'est bien passé on fait les modifications dans les tables buyer et seller
        element = find_by_email() #on retrouver l'utilisateur créer par l'email qui est unique
        if params[:user][:buyer] == "1" #S'il y a dit qu'il est acheteur on l'ajoute dans la table buyer
          Buyer.new({:user_id => element[:id]}).save()
        else
          if Buyer.find_by(user_id: element[:id]) != nil
            Buyer.find_by(user_id: element[:id]).destroy()
        
          end
        end
        if params[:user][:seller] == "1" #S'il y a dit qu'il est vendeur on l'ajoute dans la table seller
          Seller.new({:user_id => element[:id]}).save()
        else
          if Seller.find_by(user_id: element[:id]) != nil
            Seller.find_by(user_id: element[:id]).destroy()
          end
        end

        #mise à jour de la session avec les nouvelles informations
        if if_both?
          session[:buyer] = true
          session[:seller] = true
          #on considère que le profil actif par défaut est acheteur
          session[:actifProfil] = 1 #si actifProfil = 1 alors acheteur sinon vendeur
        else
          if if_buyer?
            session[:buyer] = true
            session[:actifProfil] = 1 #si actifProfil = 1 alors acheteur sinon vendeur
          else
            session[:buyer] = false
            session[:actifProfil] = 0 #si actifProfil = 1 alors acheteur sinon vendeur
          end
          if if_seller?
            session[:seller] = true
            session[:actifProfil] = 2 #si actifProfil = 1 alors acheteur sinon vendeur
          else
            session[:seller] = false
            session[:actifProfil] = 0 #si actifProfil = 1 alors acheteur sinon vendeur
          end
        end

        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :password)
    end

    def find_by_email
      @user = User.find_by_email(params[:user][:email])
    end
    
    #pour savoir si l'utilisateur connecté est vendeur et acheteur
    def if_both?
        return if_buyer?() && if_seller?()
    end
    
    #pour savoir si l'utilisateur connecté est acheteur
    def if_buyer?
        resultat = Buyer.select("id").where("user_id = " + session[:user_id].to_s)
        return resultat.length() > 0
    end

    #pour savoir si l'utilisateur connecté est vendeur
    def if_seller?
        resultat = Seller.select("id").where("user_id = " + session[:user_id].to_s)
        return resultat.length() > 0
    end
end
