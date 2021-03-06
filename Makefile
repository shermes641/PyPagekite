# Makefile for building combined pagekite.py files.

combined: pagekite tools dev
	@./scripts/breeder.py socks.py \
	             pagekite/__init__.py \
	             pagekite/httpd.py \
	             pagekite/__main__.py \
	             >pagekite-tmp.py
	@chmod +x pagekite-tmp.py
	@./scripts/blackbox-test.sh ./pagekite-tmp.py \
	        && ./scripts/blackbox-test.sh ./pagekite-tmp.py --nopyopenssl \
	        && ./scripts/blackbox-test.sh ./pagekite-tmp.py --nossl \
	        || rm pagekite-tmp.py .combined-did-not-run
	@mv pagekite-tmp.py pagekite-`./pagekite-tmp.py --appver`.py
	@ls -l pagekite-*.py

android: pagekite tools test
	@./scripts/breeder.py socks.py \
	             pagekite/__init__.py \
	             pagekite/httpd.py \
	             pagekite/__main__.py \
	             pagekite/__android__.py \
	             >pagekite-tmp.py
	@chmod +x pagekite-tmp.py
	@mv pagekite-tmp.py pk-android-`./pagekite-tmp.py --appver`.py
	@ls -l pk-android-*.py


test: dev
	@./scripts/blackbox-test.sh ./pk
	@./scripts/blackbox-test.sh ./pk --nopyopenssl
	@./scripts/blackbox-test.sh ./pk --nossl

pagekite: pagekite/__init__.py pagekite/httpd.py pagekite/__main__.py

dev: socks.py
	@rm -f .SELF
	@ln -fs . .SELF

socks.py: ../PySocksipyChain/socks.py
	@ln -fs ../PySocksipyChain/socks.py socks.py

tools: scripts/breeder.py Makefile

scripts/breeder.py:
	@ln -fs ../../PyBreeder/breeder.py scripts/breeder.py

distclean: clean
	@rm -vf pagekite-0.*.py

clean:
	@rm -vf socks.py *.pyc */*.pyc scripts/breeder.py .SELF
	@rm -vf .appver pagekite-tmp.py
