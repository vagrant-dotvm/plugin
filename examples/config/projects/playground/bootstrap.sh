# Go to %project.guest% directory, so relative paths will work here.
cd "$1"

# Ruby gems binaries go there.
PATH="/usr/local/bin:$PATH"

# Install puppet from EPEL repository
rpm --force -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
yum install -y puppet

# Install r10k - puppet module manager
gem install r10k

# Install required puppet modules
r10k puppetfile install
