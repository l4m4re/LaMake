

all: show.mk

show.mk :
	./mkshow.py > show.mk

clean: 
	rm -f show.mk
