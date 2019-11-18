## 0.5.1
* Update perlbrew to 0.87.
* Explicitly install build dependencies such as gcc and make instead of using build_essential.

## 0.5.0
* Bump minimum required Chef version to 14.
* Add a TESTING.md to document how to test chef-perlbrew.
* Unpin kitchen-dokken Chef from 14 as chefdk/chef-workstation is now updated.

## 0.4.2
* Update documentation to remove deprecated LWRP terminology.
* More tweaking of perlbrew installation.
* Pin kitchen-dokken Chef to 14 (until a newer chef-workstation with Chef 15 appears.)

## 0.4.1
* Add Amazon Linux 2 on tested/supported platforms.
* Tweak perlbrew installation so it verifies the installer script before proceeding.

## 0.4.0
* Updated for Chef 14 fixes.
* Cookbook now maintained by Zak B. Elep, thanks J.R. Mash!
* Added CI testing.

## 0.3.0
* Fixed the 'switch' resource provider to actually work.
* Fixed some things that foodcritic was complaining about.
* Updated documentation to reclect the new resource/provider, and other documentation changes.

## 0.2.0
* Created the 'default' resource/provider and converted the recipe of the same name to utilize it.
* Created the 'profile' resource/provider and converted the recipe of the same name to utilize it.
* Created the 'switch' resource/provider.

## 0.1.0
* Initial release, set forth upon an unsuspecting world.
