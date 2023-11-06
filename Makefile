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
	Include = /etc/pacman.d/apocos.mirrorlist
	[archstrike]
	Include = /etc/pacman.d/archstrike.mirrorlist
	EOF
	install -Dm0644 conf/mirrorlist build/apocos/airootfs/etc/pacman.d/mirrorlist
	install -Dm0644 conf/apocos.mirrorlist build/apocos/airootfs/etc/pacman.d/apocos.mirrorlist
	install -Dm0644 conf/archstrike.mirrorlist build/apocos/airootfs/etc/pacman.d/archstrike.mirrorlist

	cp conf/packages.x86_64 build/apocos/packages.x86_64

image: clean-workdir | build
	sudo mkarchiso -v -w /tmp/prepper-archiso-tmp -o $(CURDIR)/build $(CURDIR)/build/apocos/

clean: clean-workdir
	rm -rf build

clean-workdir:
	sudo rm -rf /tmp/prepper-archiso-tmp
