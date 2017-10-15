desc "Deploy package to AUR"
task :deploy, :pkgname do |t, args|
  name = args[:pkgname]
  cmd = %W[git subtree push -P #{name} aur-#{name} master]
  sh(*cmd)
end
