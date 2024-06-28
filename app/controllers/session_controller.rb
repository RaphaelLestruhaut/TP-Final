class SessionController < ApplicationController
    def new
    end

    def create
        user = User.find_by(email: params[:email])
        
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            if if_both?
                session[:buyer] = true
                session[:seller] = true
                #on considère que le profil actif par défaut est acheteur
                session[:actifProfil] = 1 #si actifProfil = 1 alors acheteur sinon vendeur
            elsif if_buyer?
                session[:buyer] = true
                session[:actifProfil] = 1 #si actifProfil = 1 alors acheteur sinon vendeur
            elsif if_seller?
                session[:seller] = true
                session[:actifProfil] = 2 #si actifProfil = 1 alors acheteur sinon vendeur
            else
                session[:buyer] = false
                session[:seller] = false
                session[:actifProfil] = 0 #0 pour pas de session active
            end
            redirect_to products_path
        else
            redirect_to login_path
        end
    end

    def destroy
        session[:user_id] = nil
        session[:buyer] = nil
        session[:seller] = nil
        session[:actifProfil] = nil
        redirect_to login_path
    end

    def updateSession
        if session[:actifProfil] == 1 #si actifProfil = 1 alors acheteur sinon vendeur
            session[:actifProfil] = 2 #si actifProfil = 1 alors acheteur sinon vendeur
        else
            session[:actifProfil] = 1 #si actifProfil = 1 alors acheteur sinon vendeur
        end
        redirect_back fallback_location: "/"
    end

    private 
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