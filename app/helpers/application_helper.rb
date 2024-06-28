module ApplicationHelper
    def current_user
        session[:user_id]
    end

    def logged_in?
        current_user.present?
    end

    #pour savoir si l'utilisateur connecté est vendeur et acheteur
    def if_both?
        return if_buyer?() && if_seller?()
    end
    
    #pour savoir si l'utilisateur connecté est acheteur
    def if_buyer?
        return session[:buyer] == true
    end

    #pour savoir si l'utilisateur connecté est vendeur
    def if_seller?
        return session[:seller] == true
    end

    def sessionActif
        return session[:actifProfil] 
    end

    def actif_profil_is_seller?
        return session[:actifProfil] == 2 #si actifProfil = 2 
    end

    def actif_profil_is_buyer?
        return session[:actifProfil] == 1 #si actifProfil = 1 alors acheteur 
    end

    def find_id_seller
        return Seller.select("id").where("user_id = " + current_user.to_s)[0][:id]
    end

    def find_id_buyer
        return Buyer.select("id").where("user_id = " + current_user.to_s)[0][:id]
    end
end
