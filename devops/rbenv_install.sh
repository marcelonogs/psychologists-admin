echo Installing Rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

echo Installing Ruby Build
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build