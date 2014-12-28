sleep 10

cd /src/abstract-totalvalidator
python2.7 setup.py develop

# totalvalidator crawl -L 10 http://abstract.it /src/var/abstract.it/crawl

# totalvalidator check /src/config/totalvalidator.cfg /src/var/abstract.it/crawl /src/var/abstract.it/check
# -L 10 http://abstract.it /src/crawl/abstract

cd /src/totalvalidatorfrontend
python2.7 setup.py develop

pserve /src/config/totalvalidatorfrontend.ini
