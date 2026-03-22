### 1. Clone the repo

Cloning the `nix` branch using `jj` from the Strawmelonjuice forge:

```bash
# Temporary pre-install these required packages
nix shell nixpkgs#git nixpkgs#jujutsu nixpkgs#neovim --extra-experimental-features nix-command --extra-experimental-features flakes

# Clone the dotfiles
jj git clone https://git.nuv.sh/nuv/nix.git -b main ~/.dotfiles

cd ~/.dotfiles
# Set origin correctly for dotfiles, assuming you by the time you push again have the keys.
jj git remote set-url origin ssh://git@git.nuv.sh/nuv/nix.git

# Clone wallpapers.
jj git clone https://github.com/D3Ext/aesthetic-wallpapers.git ~/.local/share/wallpapers/aesthetic-wallpapers
```

2. Initialize a new Host if this is a brand new device:
```bash
mkdir -p hosts/$(hostname) # Create the folder
cp /etc/nixos/*.nix ./hosts/$(hostname)/ # Copy installer configs
nvim ./flake.nix # Include the new hostname in the nixosConfigurations block.
nvim ./hosts/$(hostname)/configuration.nix # You may want to tweak this, or maybe import `../all-hosts.nix`!
```
Otherwise make sure the hostname matches the one before and continue to 3!

3. Deploy
```Bash
jj # Capture new files so the flake can see them
sudo nixos-rebuild switch --flake .#$(hostname) # Apply based on current hostname

# If you included all-hosts.nix, you now won't have sudo anymore, so make sure doas works!

doas git config --global --add safe.directory /home/liv/.dotfiles # Safelist dotfiles for root, so doas can be used to rebuild!
```

## Structure

| Directory   | For                                                                                                  |
| ----------- | ---------------------------------------------------------------------------------------------------- |
| `hosts/*`   | Device-specific hardware and system settings (e.g., Fennekin's convertible tweaks).                  |
| `home/*`    | Shared user environment and config                                                                   |
| `configs/*` | Configuration files symlinked into their programs for when configuration is too advanced for `home/` |
| `fonts/*`   | Fonts, imported by `home/modules/fonts.nix`                                                          |

## Hosts currently known

| Name     | Kind               | About                                                     | Special                                                                       |
| -------- | ------------------ | --------------------------------------------------------- | ----------------------------------------------------------------------------- |
| shitbox | e-waste laptop | pretty much just a media laptop | |
| beeg-puter | my main desktop | Ryzen 9 7900X + 32gig + 3090 | |

## TODO
nix:
- replace p10k with starship
- commit signing (has to work with jj split)
- sops for logins n such (maybe ssh keys as well; we'll see)

nvim:
- breadog based theme
- lil startup page mayhaps
- theme switcher
- auto theme switching (based on current os theme)
