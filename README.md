# APTrust Ansible Config Files

These files are used to configure and manage servers and services for the
Academic Preservation Trust.

These are very early files as we are getting use to ansible and particularly
getting use to ansible best practices and they are prone to change often.

# External Var Files
Private variables are stored in an external folder.  See the Lead Engineer for
access these external folders. It should be copied to your home directory under
the ~/.ansible directory to work approparitely.

Eventually we will be calling this via a command line argument but for now
just put it where we indicate above.

## Vagrant Setup

You can set up a local development environment to build, run, develop
and test both Fluctus and the APTrust Go services. First, download and
install [Vagrant](https://docs.vagrantup.com/v2/installation/).

Copy the Vagrant file in this repository to the directory where you
want to install your Vagrant virtual machine. This documentation
assumes you are running Vagrant under ~/aptrust.

Note that the Vagrant file gives the virtual machine 8 processors and
2GB of RAM. You will need all of that RAM to build some of the Go
binaries if you stick with the 8 processor setting, because Go will
use 8 go-routines to build the source. If you want to use a more
lightweight VM, reduce the number of CPU cores and memory in
tandem. For example, you can do 2 cores and 1 GB of RAM.

You should be able to bring up your Vagrant virtual machine with this
command:

> vagrant up

The following command will print out settings that you can copy
directly into your ~/.ssh/config file. These settings can ease the
process of running your ansible playbooks against the VM.

> vagrant ssh-config

Now cd into the ansible-playbooks directory (the one that contains
this README file) and run the following:

> ansible-playbook vagrant.yml

The playbook will likely take 20 or more minutes to run, because it
does quite a bit of work.

You can connect to the Vagrant via SSH with this command:

> vagrant ssh

You'll be logged in as user vagrant. Now do this:

> cd ~/go/src/github.com/APTrust/bagman/bagman/
> go test

You should see output like this:

Skipping fluctus integration tests: Fluctus server is not running at http://localhost:3000
Skipping IngestHelper tests because Fluctus is not running at http://localhost:3000
PASS
ok      github.com/APTrust/bagman/bagman        36.316s

Now finish setting up Fluctus. You should not have to run migrations
the first time, since the Ansible setup did that for you.

> cd ~/aptrust/fluctus

> bundle exec rake jetty:start

Jetty will take a while to start. Once it's running, run setup to
create an admin account.

> bundle exec rake fluctus:setup

Run this to create the required institutions:

> bundle exec rake fluctus:reset_data

Run the spec tests. These will take a few minutes to complete.

> bundle exec rake spec

Start the Rails app:

> rails server

Now, from your host machine, if you go to http://192.168.33.10:3000/,
you can log in to the Rails app with the email and password you
created when you ran the fluctus:setup task.

After logging in, go to the Admin menu and click New User. Create a
user with email address system@aptrust.org. Make sure this user has
the Admin role at the APTrust institution.

After creating the user, click the button to Generate API Secret
Key. Copy the API key into ~/.bash_profile on your Vagrant box. The Go
services will use system@aptrust.org with the specified API key to
talk to Fluctus. You should have the following lines in your
~/.bash_profile:

export FLUCTUS_API_USER='system@aptrust.org'
export FLUCTUS_API_KEY='<the key you just generated>'

Run this to reload your ~/.bash_profile:

> source ~/.bash_profile

With the Rails server still running, open another ssh connection using
vagrant ssh, and do this:

> cd ~/go/src/github.com/APTrust/bagman/

> ./scripts/process_items.sh

The process_items script ingests a number of bags from our AWS test
bucket into your local Fluctus app. It takes a few minutes to run, and
it does print at least one error (an invalid bag that we want to make
sure the system handles correctly). When the script is done, go back
to your browser, click the Processed Items tab at the top, then click
the Search button. You should see 11 items: 9 that succeeded and 2
that failed for invalid format.

Now click the Objects & Files tab and then click the Search
button. Click one of the 9 objects, then click the Delete button. You
should see a list of Pending delete operations.

Now click the Objects & Files, then Search again. Click any object,
then click its Restore Object button.

Click the Processed Items tab, then Search, and you'll see one item
Pending restore.

Now go back to the Vagrant SSH session where you ran the process_items
script. Kill the script with Control+C. Now run this:

> ./scripts/restore_items

That script handles pending restore and delete requests. It should
complete within 30 seconds if there are no network issues.

Go back to your browser and search again for Processed Items. At the
top of the list, you should see that the restore and delete operations
were all successful.

You can now run one last test. Because Rails is now set up and
running, the Go tests will run several interaction tests. This may
take two minutes or more.

> cd ~/cd go/src/github.com/APTrust/bagman/bagman/
> go test

### Troubleshooting Your Vagrant Setup

If Ansible has trouble connecting to your Vagrant VM, try running:

> vagrant ssh-config

Note the path to the private key file in the vagrant output. Then run
this.

> ansible-playbook vagrant.yml -vvvv

In the command output, look at the private keys SSH tries to use. If
it does not match what the vagrant command printed, copy the output of
vagrant ssh-config into your ~/.ssh/config file.

If you have destroyed and re-created your Vagrant VM, the SSH
fingerprint of the new VM will not match the fingerprint of the old
VM. Ansible will fail to connect but will not give a meaningful
error. Open ~/.ssh/known_hosts and delete the entry for host
192.168.33.10, then try again.
