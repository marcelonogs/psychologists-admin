# Welcome to Psychologists-admin

Psychologists-admin is an application made for psychologists out there that would like to
have a platform to have their patients and to issue bills (adapted to Swiss payment system).

## Getting Started

```shell
git clone git@github.com:born4new/psychologists-admin.git
cd psychologists-admin/devops
vagrant up
vagrant ssh
rbenv install 2.1.2
rbenv rehash
rbenv global 2.1.2
gem install bundler
bundle install
rake db:setup
rails server
```
``` I have typed the first line of command on terminal "bash" - but it is giving an fatal error: permission denied - could not read from remote repository -- maybe is because i suppose to have a repository first? how to do it? thanks bro :)```
You should see the login page, **level 1** completed!
