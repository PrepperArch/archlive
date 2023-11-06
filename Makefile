.ONESHELL:

all: clean image

build:
	mkdir -p build/apocos
	cp -r /usr/share/archiso/configs/baseline/* build/apocos
	cp conf/profiledef-x86_64.sh build/apocos/profiledef.sh

	mkdir -p build/apocos/airootfs/usr/local/bin
	install -Dm0755 conf/firstboot.sh  build/apocos/airootfs/usr/local/bin
	mkdir -p build/apocos/airootfs/etc/systemd/system
	install -Dm0644 conf/firstboot.service build/apocos/airootfs/etc/systemd/system
	mkdir -p build/apocos/airootfs/etc/systemd/system/multi-user.target.wants
	ln -s /etc/systemd/system/firstboot.service build/apocos/airootfs/etc/systemd/system/multi-user.target.wants/firstboot.service

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
