#---------------------------------------------------------------------------
# Linux Device Tree Overlays
#---------------------------------------------------------------------------




define gen-overlay
	@echo "Making $@ ... " $(TEE)
	@-$(COMPILE.dt)  $<  -o $@ $(OUT)
endef


$(BINDIR)/%-$(VERSION.dt).dtbo : %.dts
	$(gen-overlay)



#---

NAME.dt ?= $(notdir $(ALLSRC.dt:%.dts=%))


.PHONY: installudev.dt installbin.dt install.dt

# install overlay binaries (in /lib/firmware)
installbin.dt: $(INST_TARGETS_BIN.dt)

$(INST_TARGETS_BIN.dt):
	@echo "Installing $(NAME.dt) .."
	@echo "    ..install overlay binary.."
	@$(MKDIR_P) $(INST_DIR_BIN.dt)
	@$(INSTALL) $(INST_FILES_BIN.dt) $(INST_DIR_BIN.dt)

# install udev rules (in /etc/udev/rules.d)
installudev.dt: $(INST_TARGETS_UDEV.dt)

$(INST_TARGETS_UDEV.dt):
	@echo "    ..install udev rules.."
	@$(MKDIR_P) $(INST_DIR_UDEV.dt)
	@$(INSTALL) $(INST_FILES_UDEV.dt) $(INST_DIR_UDEV.dt)

install.dt: $(TARGETS.dt) installbin.dt installudev.dt


# TODO: handle post-install along example in Makefile.i2c1
#       see: https://github.com/IlikePepsi/dt-overlays
#       The scripts from there are in tools subdir in LaMake. 
#       Could be a "make load" and "make unload"

