default:
  @just -l

# generate .SRCINFO for {{pkg}}
srcinfo pkg:
  cd {{pkg}} && makepkg -C --printsrcinfo > .SRCINFO

# push {{pkg}} to AUR
deploy pkg:
  git subtree push -P {{pkg}} ssh://aur@aur.archlinux.org/{{pkg}}.git master
