# Elixir Concurrent EmailServer

## Getting started


### Installation
On your Ubuntu 18.04 server, run these commands, answering `y` to all prompts:
```
# Install Elixir and Erlang
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang
sudo apt-get install elixir

# Install this repo and get into it
cd /opt/
git clone https://github.com/flyrboy96/email_server.git
cd email_server
sudo su
```

### Deployment
Set your MailGun API Key with the following command: `export MAILGUN_API_KEY=<Your MailGun API Key>`

```
mix deps.get
MIX_ENV=prod PORT=80 elixir --detached -S mix do compile, phx.server
```


