# Composer template for Drupal projects on Aegir & DevShop.

This project template provides a starter kit for managing your site
dependencies with [Composer](https://getcomposer.org/), tuned to run on Aegir or DevShop.

It is based on the [drupal-composer/drupal-project](https://github.com/drupal-composer/drupal-project).

## Usage

First you need to [install composer](https://getcomposer.org/doc/00-intro.md#installation-linux-unix-osx).

> Note: The instructions below refer to the [global composer installation](https://getcomposer.org/doc/00-intro.md#globally).
You might need to replace `composer` with `php composer.phar` (or similar) 
for your setup.

After that you can create the project:

```
composer create-project devshop/composer-template:8.x-dev --stability dev --no-interaction mynewproject
```

With `composer require ...` you can download new dependencies to your 
installation.

```
cd some-dir
composer require drupal/devel:~1.0
```

The `composer create-project` command passes ownership of all files to the 
project that is created. You should create a new git repository, and commit 
all files not excluded by the .gitignore file.

## What does this template do?

- Adds a `composer drupal:upgrade` command as an alias for `composer update drupal/core webflo/drupal-core-require-dev symfony/* --with-dependencies`
- Downgrades to drush 8. (I'm so sorry. Soon, I promise.)
- Adds aegir files to .gitignore.
- Sets config.platform.php to 5.5 for greatest compatibility.
- Adds a /tests folder with Drupal Behat Tests ready to go. (TODO)
- Uses the [drupal-scaffold](https://github.com/drupal-composer/drupal-scaffold) plugin to download the scaffold files (like index.php, update.php, …) to the web/ directory of your project. For more on this, see the section entitled "Should I commit the scaffolding files?", below.

## What does the parent project (drupal-composer/drupal-project) do?

When installing the given `composer.json` some tasks are taken care of:

* Drupal will be installed in the `web`-directory.
* Autoloader is implemented to use the generated composer autoloader in `vendor/autoload.php`,
  instead of the one provided by Drupal (`web/vendor/autoload.php`).
* Modules (packages of type `drupal-module`) will be placed in `web/modules/contrib/`
* Theme (packages of type `drupal-theme`) will be placed in `web/themes/contrib/`
* Profiles (packages of type `drupal-profile`) will be placed in `web/profiles/contrib/`
* Creates default writable versions of `settings.php` and `services.yml`.
* Creates `web/sites/default/files`-directory.
* Latest version of drush is installed locally for use at `vendor/bin/drush`.
* Latest version of DrupalConsole is installed locally for use at `vendor/bin/drupal`.
* Creates environment variables based on your .env file. See [.env.example](.env.example).

## Updating Drupal Core

This project will attempt to keep all of your Drupal Core files up-to-date; the 
project [drupal-composer/drupal-scaffold](https://github.com/drupal-composer/drupal-scaffold) 
is used to ensure that your scaffold files are updated every time drupal/core is 
updated. If you customize any of the "scaffolding" files (commonly .htaccess), 
you may need to merge conflicts if any of your modified files are updated in a 
new release of Drupal core.

Follow the steps below to update your core files.

1. Run `composer update drupal/core webflo/drupal-core-require-dev symfony/* --with-dependencies` to update Drupal Core and its dependencies.
1. Run `git diff` to determine if any of the scaffolding files have changed. 
   Review the files for any changes and restore any customizations to 
  `.htaccess` or `robots.txt`.
1. Commit everything all together in a single commit, so `web` will remain in
   sync with the `core` when checking out branches or running `git bisect`.
1. In the event that there are non-trivial conflicts in step 2, you may wish 
   to perform these steps on a branch, and use `git merge` to combine the 
   updated core files with your customized files. This facilitates the use 
   of a [three-way merge tool such as kdiff3](http://www.gitshah.com/2010/12/how-to-setup-kdiff-as-diff-tool-for-git.html). This setup is not necessary if your changes are simple; 
   keeping all of your modifications at the beginning or end of the file is a 
   good strategy to keep merges easy.

## Generate composer.json from existing project

With using [the "Composer Generate" drush extension](https://www.drupal.org/project/composer_generate)
you can now generate a basic `composer.json` file from an existing project. Note
that the generated `composer.json` might differ from this project's file.


## FAQ

### Should I commit the contrib modules I download?

Composer recommends **no**. They provide [argumentation against but also 
workrounds if a project decides to do it anyway](https://getcomposer.org/doc/faqs/should-i-commit-the-dependencies-in-my-vendor-directory.md).

### Should I commit the scaffolding files?

You don't need to, and by default, your changes will be overwritten. If you're considering it, **read on**. The [drupal-scaffold](https://github.com/drupal-composer/drupal-scaffold) plugin downloads the scaffold files (like
index.php, update.php, …) to the web/ directory of your project, through registering `@composer drupal:scaffold` as post-install and post-update commands in composer.json. If you have customized those files, you could choose to check them into your version control system (e.g. git). If that is the case for your project, you should remove the following line from both "post-install-cmd", and "post-update-cmd" in the project's composer.json: 

```json
"@composer drupal:scaffold",
```
### How can I apply patches to downloaded modules?

If you need to apply patches (depending on the project being modified, a pull 
request is often a better solution), you can do so with the 
[composer-patches](https://github.com/cweagans/composer-patches) plugin.

To add a patch to drupal module foobar insert the patches section in the extra 
section of composer.json:
```json
"extra": {
    "patches": {
        "drupal/foobar": {
            "Patch description": "URL or local path to patch"
        }
    }
}
```
### How do I switch from packagist.drupal-composer.org to packages.drupal.org?

Follow the instructions in the [documentation on drupal.org](https://www.drupal.org/docs/develop/using-composer/using-packagesdrupalorg).

### How do I specify a PHP version ?

Currently Drupal 8 supports PHP 5.5.9 as minimum version (see [Drupal 8 PHP requirements](https://www.drupal.org/docs/8/system-requirements/drupal-8-php-requirements)), however it's possible that a `composer update` will upgrade some package that will then require PHP 7+.

To prevent this you can add this code to specify the PHP version you want to use in the `config` section of `composer.json`:
```json
"config": {
    "sort-packages": true,
    "platform": {"php": "5.5.9"}
},
```

# Support

This project is supported by ThinkDrop Inc and the DevShop.Support service. See https://devshop.support for more information.

