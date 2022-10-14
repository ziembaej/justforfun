## Source: https://guides.rubyonrails.org/getting_started.html
# Check/confirm versions of key packages
#
ruby --version
sqlite3 --version
rails --version

## Rails comes with a number of scripts called generators that are designed to make your development life easier by creating 
## everything that's necessary to start working on a particular 
## task. One of these is the new application generator, 
## which will provide you with the foundation of a fresh Rails 
## application so that you don't have to write it yourself.

## To use this generator, open a terminal, navigate to a directory where you have rights to create files, and run:
# added [--skip] to allow the full setup script to rerun even if a blog was created previously
# rails new blog --skip


## command line options for `rails new`
# rails new --help

## go to the blog dir
cd blog

## start a server on localhost
bin/rails server

