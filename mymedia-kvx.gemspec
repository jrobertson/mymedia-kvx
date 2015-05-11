Gem::Specification.new do |s|
  s.name = 'mymedia-kvx'
  s.version = '0.2.2'
  s.summary = 'Publishes Kvx files using the MyMedia framework'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_runtime_dependency('mymedia', '~> 0.2', '>=0.2.5')
  s.signing_key = '../privatekeys/mymedia-kvx.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/mymedia-kvx'
end
