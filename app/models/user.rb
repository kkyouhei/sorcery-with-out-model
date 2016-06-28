class User
  include ActiveAttr::Model

  attribute :id
  attribute :email
  attribute :password
  attribute :crypted_password

  class << self
    def authenticate(*credentials)
      require 'json'
      require 'net/http'
      require 'uri'
      require 'openssl'
      require 'jwt'

      uri = URI.parse('http://192.168.33.204:3000/users/sign_in')
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Post.new(uri.request_uri)
      req["Content-Type"] = "application/json"
      mail, pass = credentials[0], credentials[1]
      req.body = {:user=>{:email=>mail, :password=>pass, service: 4}}.to_json
      res = http.request(req)
      rsa_public = OpenSSL::PKey.read ENV["RSA_PUBLIC"]
      session_data = JWT.decode JSON.parse(res.body)['token'], rsa_public, true, algorithm: 'RS256'
      data = session_data.first
      User.new(id: data["uid"], email: data["email"])
    end
  end
end
