#!/bin/sh -xe

VENV_NAME=${VENV_NAME:-venv}

# .egg-info directories tend to cause bizzaire problems (e.g. `pip -e
# .` might unexpectedly install letshelp-certbot only, in case
# `python letshelp-certbot/setup.py build` has been called
# earlier)
rm -rf *.egg-info

# virtualenv setup is NOT idempotent: shutil.Error:
# `/home/jakub/dev/letsencrypt/letsencrypt/venv/bin/python2` and
# `venv/bin/python2` are the same file
mv $VENV_NAME "$VENV_NAME.$(date +%s).bak" || true
virtualenv --no-site-packages $VENV_NAME $VENV_ARGS
echo 'DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"' >> $VENV_NAME/bin/activate
echo 'alias certbot="$DIR./certbot --config-dir $DIR../../config --logs-dir $DIR../../logs --work-dir $DIR../../work"' >> $VENV_NAME/bin/activate
. ./$VENV_NAME/bin/activate

# Separately install setuptools and pip to make sure following
# invocations use latest
pip install -U setuptools
pip install -U pip
pip install "$@"

set +x
echo "Please run the following command to activate developer environment:"
echo "source $VENV_NAME/bin/activate"
