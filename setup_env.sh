#!/bin/bash
set -e

WORKING_DIR=$(pwd)
PYTHON_VER="3.10.13"

echo "📂 Setting up Odoo 17 Environment in $WORKING_DIR..."

# 1. Install pyenv and Python 3.10 if missing
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if ! command -v pyenv &> /dev/null; then
    curl https://pyenv.run | bash
    eval "$(pyenv init -)"
fi

if ! pyenv versions | grep -q "$PYTHON_VER"; then
    echo "🐍 Installing Python $PYTHON_VER..."
    pyenv install $PYTHON_VER -s
fi

# 2. Clone Odoo into 'odoo' folder
cd $WORKING_DIR
if [ ! -d "odoo" ]; then
    git clone https://www.github.com/odoo/odoo --depth 1 --branch 17.0 odoo
fi

# 3. Create 'odoo-venv'
if [ ! -d "odoo-venv" ]; then
    echo "🍦 Creating odoo-venv..."
    $(pyenv root)/versions/$PYTHON_VER/bin/python -m venv odoo-venv
fi

# 4. Create odoo.conf
if [ ! -f "odoo.conf" ]; then
    echo "📝 Generating odoo.conf..."
    cat <<EOF > odoo.conf
[options]
admin_passwd = admin
db_host = localhost
db_user = odoo
db_password = odoo
db_port = 5432
addons_path = $WORKING_DIR/odoo/addons
EOF
fi

echo "✅ Environment Ready! Now run: source odoo-venv/bin/activate"
