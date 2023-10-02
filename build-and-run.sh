# delete old app.zip
rm -f app/src/app.zip
rm -f app/src/requirements.txt

# download and extract ferme-ta-gueule
# wget https://github.com/gregorg/ferme-ta-gueule/archive/refs/heads/master.zip
# unzip -q master.zip -d app/src
# rm -f master.zip
cd app/src

# generate requirements.txt from poetry.lock
poetry export --without-hashes --format=requirements.txt > requirements.txt
echo "flask" >> ./requirements.txt
cd ../..

# zip app
dart run serious_python:main package app/src

flutter run
