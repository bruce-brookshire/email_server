# Elixir Concurrent EmailServer

# Getting started


## Installation
On your Ubuntu 18.04 server, run these to install elixir
```
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang
sudo apt-get install elixir
```

* Change directories with `$ cd /opt/`
* Clone this repository: `$ git clone https://github.com/flyrboy96/email_server.git`
* CD into that directory: `$ cd email_server`
* Become sudo `$ sudo su`

## Deployment
Set your MailGun API Key with the following command: `# export MAILGUN_API_KEY=<Your MailGun API Key>`

Now run the following, answering `y` to all prompts:

```
# mix deps.get
# MIX_ENV=prod PORT=80 elixir --detached -S mix do compile, phx.server
```


