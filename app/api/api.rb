class Api < Grape::API
  format :json

  resource :status do
    desc 'Return statuses of domains.'
    get do
      all = Domain.all
      all.each do |el| 
        # UpdateDomainWorker.perform_async(el.address)
        # UpdateDomainWorker.perform_in(20.minutes, el.address)
      end
      all
    end
  end

  resource :domain do
    desc 'Create a domain.'
    params do
      requires :address, type: String, desc: 'New domain.'
    end
    post do
      address = params[:address].gsub('http://','').gsub('https://','')
      Domain.create!({
        address: address,
        status: false,
        desc: 'New domain'
      })
      UpdateDomainWorker.perform_async(address)
      UpdateDomainWorker.perform_in(20.minutes, el.address)
    end
  end
end