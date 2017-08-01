Gem::Specification.new do |s|
  s.name = 'mymedia-kvx'
  s.version = '0.4.1'
  s.summary = 'Publishes Kvx files using the MyMedia framework'
  s.authors = ['James Robertson']
  s.files = Dir['lib/mymedia-kvx.rb']
  s.add_runtime_dependency('mymedia', '~> 0.2', '>=0.2.11')
  s.add_runtime_dependency('martile', '~> 0.6', '>=0.6.26')
  s.add_runtime_dependency('nokogiri', '~> 1.8', '>=1.8.0')
  s.signing_key = '../privatekeys/mymedia-kvx.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/mymedia-kvx'
end
