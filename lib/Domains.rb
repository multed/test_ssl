class API < Grape::API
  format :json

  resource :status do

    desc 'Return statuses of domains.'
    get do
      Domain.all
      # authenticate!
      # current_user.statuses.limit(20)
    end
  end

  resource :domain do
    desc 'Create a domain.'
    params do
      requires :address, type: String, desc: 'New domain.'
    end
    post do
      Domain.create!({
        address: params[:address],
        status: 0
      }) 
      # authenticate!
      # Status.create!({
      #   user: current_user,
      #   text: params[:status]
      # })
    end
  end
end