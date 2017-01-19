#require 'https'

#http = Net::HTTP.new('localhost', 3000)
#http.use_ssl = true
#http.verify_mode = OpenSSL::SSL::VERIFY_PEER

#http.cert_store = OpenSSL::X509::Store.new
#http.cert_store.set_default_paths
#http.cert_store.add_file(RAILS_ROOT.concat("cacert.pem"))
# ...or:
#cert = OpenSSL::X509::Certificate.new(File.read('certificate.pem'))
#http.cert_store.add_cert(cert)
#require "openssl"
#puts "SSL_CERT_FILE: %s" % OpenSSL::X509::DEFAULT_CERT_FILE
#puts "SSL_CERT_DIR: %s" % OpenSSL::X509::DEFAULT_CERT_DIR
#require 'open-uri'
#require 'net/https'
#require 'open-uri'
#require 'net/https'

#module Net
#  class HTTP
#    alias_method :original_use_ssl=, :use_ssl=

#    def use_ssl=(flag)
#      self.ca_file = "/etc/ssl/certs/ca-certificates.crt"  # for Centos/Redhat
#      self.verify_mode = OpenSSL::SSL::VERIFY_PEER
#      self.original_use_ssl = flag
#    end
#  end
#end
# require 'openssl'
# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE