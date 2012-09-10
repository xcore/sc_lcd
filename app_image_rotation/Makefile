include BuildOptions

BINDIR = bin
TMPDIR = .build
TARGET = $(BINDIR)/$(APPNAME).xe
OBJS = $(addsuffix .o, $(addprefix $(TMPDIR)/, $(OBJNAMES)))
MODULESRCDIR = ../$(MODULE)/src
MODULESRCDIR1 = ../$(MODULE)/src/$(LCD_TARGET)
APPSRCDIR = src
XNFILE = $(APPSRCDIR)/$(XNFILENAME)
INCLUDES = $(addprefix -I../, $(APPSRCDIR) $(MODULESRCDIR) $(MODULESRCDIR1))

all: $(TARGET)

clean:
	rm -rf bin .build

$(TMPDIR)/%.o: $(APPSRCDIR)/%.c $(XNFILE)
	cd $(TMPDIR) && xcc -c $(COMPILEFLAGS) $(INCLUDES) ../$< ../$(XNFILE) -o ../$@

$(TMPDIR)/%.o: $(APPSRCDIR)/%.xc $(XNFILE)
	cd $(TMPDIR) && xcc -c $(COMPILEFLAGS) $(INCLUDES) ../$< ../$(XNFILE) -o ../$@

$(TMPDIR)/%.o: $(MODULESRCDIR)/%.xc $(XNFILE)
	cd $(TMPDIR) && xcc -c $(COMPILEFLAGS) $(INCLUDES) ../$< ../$(XNFILE) -o ../$@

$(TMPDIR)/%.o: $(MODULESRCDIR)/%.S $(XNFILE)
	cd $(TMPDIR) && xcc -c $(COMPILEFLAGS) $(INCLUDES) ../$< ../$(XNFILE) -o ../$@
	
$(TMPDIR)/%.o: $(MODULESRCDIR1)/%.xc $(XNFILE)
	cd $(TMPDIR) && xcc -c $(COMPILEFLAGS) $(INCLUDES) ../$< ../$(XNFILE) -o ../$@

$(TMPDIR)/%.o: $(MODULESRCDIR1)/%.S $(XNFILE)
	cd $(TMPDIR) && xcc -c $(COMPILEFLAGS) $(INCLUDES) ../$< ../$(XNFILE) -o ../$@
	
$(TARGET): $(TMPDIR) $(BINDIR) $(OBJS)
	xcc $(LINKFLAGS) $(OBJS) $(XNFILE) -o $(TARGET)
	xobjdump -d $(TARGET) > $(TARGET).txt
	cd $(BINDIR) && xobjdump --split ../$(TARGET)

$(TMPDIR):
	-@mkdir -p $(TMPDIR)

$(BINDIR):
	-@mkdir -p $(BINDIR)
