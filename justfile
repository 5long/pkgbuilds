default:
  @just -l

### Playbook:
# - update version number in PKGBUILD
# - `just up <pkg>`
# - `just bi <pkg>` to test it out
# - commit changes to git
# - `just deploy <pkg>`

# makepkg --geninteg for {{pkg}}
geninteg pkg:
  cd {{pkg}} && test -w PKGBUILD \
  && ruby -i -ne 'print $_ if not /^sha256sums=/ .. /^$/ ' PKGBUILD \
  && makepkg -g >> PKGBUILD

# generate .SRCINFO for {{pkg}}
srcinfo pkg:
  cd {{pkg}} && makepkg -C --printsrcinfo > .SRCINFO

# update {{pkg}}
up pkg:
  @just geninteg {{pkg}}
  @just srcinfo {{pkg}}

# build & install {{pkg}}
bi pkg:
  cd {{pkg}} && makepkg -si --nocheck

# push {{pkg}} to AUR
deploy pkg:
  git subtree push -P {{pkg}} ssh://aur@aur.archlinux.org/{{pkg}}.git master
