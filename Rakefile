desc "Deploy package to AUR"
task :deploy, :pkgname do |t, args|
  name = args[:pkgname]
  cmd = %W[git subtree push -P #{name} ssh://aur@aur.archlinux.org/#{name}.git master]
  sh(*cmd)
end
