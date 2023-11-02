.ONESHELL:

all: clean image

build:
	mkdir -p build/apocos
	cp -r /usr/share/archiso/configs/baseline/* build/apocos
	cp conf/profiledef-x86_64.sh build/apocos/profiledef.sh
	cat /usr/share/archiso/configs/baseline/pacman.conf - <<- EOF > build/apocos/pacman.conf
	[apocos]
	SigLevel = Optional TrustAll
	Server = https://raw.github.com/PrepperArch/apocos-repo/main/any
	EOF
	cp conf/packages.x86_64 build/apocos/packages.x86_64

image: clean-workdir | build
	sudo mkarchiso -v -w /tmp/prepper-archiso-tmp -o $(CURDIR)/build $(CURDIR)/build/apocos/

clean: clean-workdir
	rm -rf build

clean-workdir:
	sudo rm -rf /tmp/prepper-archiso-tmp
