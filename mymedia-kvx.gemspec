Gem::Specification.new do |s|
  s.name = 'mymedia-kvx'
  s.version = '0.4.2'
  s.summary = 'Publishes Kvx files using the MyMedia framework'
  s.authors = ['James Robertson']
  s.files = Dir['lib/mymedia-kvx.rb']
  s.add_runtime_dependency('mymedia', '~> 0.2', '>=0.2.14')
  s.add_runtime_dependency('martile', '~> 1.3', '>=1.3.0')
  s.add_runtime_dependency('nokogiri', '~> 1.10', '>=1.10.5')
  s.signing_key = '../privatekeys/mymedia-kvx.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/mymedia-kvx'
end
