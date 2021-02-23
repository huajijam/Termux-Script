sudo chown -R 10269:10269 $HOME/github
cd $HOME/github&&find . -type d  | xargs -i chmod 700 {}&&find . -type f  | xargs -i chmod 600 {}
