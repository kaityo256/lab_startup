TARGET=$(shell ls */README.md | sed 's/README.md/index.html/')
PANDOC=pandoc -s --mathjax -t html --template=template

all: $(TARGET) index.html

index.html: README.md
	sed 's/README.md/index.html/' README.md > index.md
	$(PANDOC) --metadata pagetitle=$< index.md -o $@
	rm -f index.md


%/index.html: %/README.md
	$(PANDOC) $< --metadata pagetitle=$< -o $@

clean:
	rm -f $(TARGET) index.html
