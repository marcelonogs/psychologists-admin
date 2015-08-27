echo Installing Rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

echo Installing Ruby Build
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# Note: Before doing this one, you need to remove the first lines of the .bashrc about non-interactive shells.
echo Installing Ruby 2.1.2
source /home/vagrant/.bashrc
rbenv install 2.1.2
rbenv global 2.1.2