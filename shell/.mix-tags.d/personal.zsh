# --- PERSONAL MACHINES ----------------------------
# Product repos, deploy tooling, anything that must never reach a work machine.
# Secrets still go in ~/.mix-extra — this file is committed.

# Laravel
alias artisan='php artisan'
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

# Laravel Composer
export PATH=$PATH:$HOME/.composer/vendor/bin
