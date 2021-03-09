echo -e **Running Script V1.1**
sudo chown -R 10269:10269 $HOME/github
echo -e Folder Owner Setting Complete
cd $HOME/github
find . -type d  | xargs -i chmod 700 {}
echo -e Folder Permission Setting Complete
find . -type f  | xargs -i chmod 600 {}
echo -e File Permission Setting Complete