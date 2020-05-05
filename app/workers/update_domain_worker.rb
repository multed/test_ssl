class UpdateDomainWorker
  include Sidekiq::Worker
  require 'net/http'
  require 'openssl'

  def perform(address)
    dom = Domain.find_by address: address
    if dom
      uri = URI('https://' + dom.address)
      begin 
        Net::HTTP.start(
          uri.host,
          uri.port,
          :use_ssl => true
        ) do |http|
          @cert = http.peer_cert
        end
      rescue OpenSSL::SSL::SSLError
        case $!.message
        when /certificate has expired/
          dom.status = false
          dom.desc = 'Сертификат истёк'
        else
          dom.status = false
          dom.desc = 'Ошибка SSL'
        end
      rescue
        dom.status = false
          dom.desc = 'Ошибка установки соединения, не связанная с SSL'
      else
        case 
        when (@cert.not_after - Time.now)/60/60/24 < 7
          dom.status = false
          dom.desc = 'Сертификат истекает менее чем через 1 неделю'
        when (@cert.not_after - Time.now)/60/60/24 < 14
          dom.status = false
          dom.desc = 'Сертификат истекает менее чем через 2 недели'
        else
          dom.status = true
          dom.desc = 'Всё хорошо'
        end
      ensure
        dom.save!
      end
    end
  end
end