# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

############# Dependencies #################

# core
def core
  pod 'RxSwift'
  pod 'RxCocoa'
  # image download/cache
  pod 'Kingfisher'
end

# network
def network
  pod 'Moya/RxSwift'
end

# uicomponent
def uicomponent
  # layout
  pod 'SnapKit'
end

#tests
def tests
  pod 'RxTest'
  pod 'RxBlocking'
end

#############################################


################ Targets ####################

target 'MarvelHeroes' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  core
  
  # project keys
  plugin 'cocoapods-keys', {
      :project => "MarvelHeroes",
      :keys => [
        "MarvelApiKey",
        "MarvelPrivateKey"
      ]}

  
  target 'MarvelHeroesTests' do
    inherit! :search_paths
    tests
  end


  target 'MarvelHeroesUITests' do
    # Pods for testing
  end

end

target 'MarvelCore' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  core
  
  target 'MarvelCoreTests' do
    inherit! :search_paths
    tests
  end

end


target 'MarvelNetwork' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  core
  network
  
  target 'MarvelNetworkTests' do
    inherit! :search_paths
    tests
  end

end


target 'MarvelUI' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  core
  uicomponent
  
  target 'MarvelUITests' do
    inherit! :search_paths
    tests
  end

end

target 'MarvelDomain' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  target 'MarvelDomainTests' do
    inherit! :search_paths
  end

end

#############################################




