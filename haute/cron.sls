make_sure_log_dir_exists:
  cmd.run:
    - name: "mkdir -p /var/log/haute"

haute_crontab:
  cmd.run:
    - name: "su -s /bin/bash -c \"echo '# Order 1 week update and 1 week surver\n45 9 * * * /usr/bin/php /src/haute/batch/email_customer_survery_week_1.php >> /var/log/haute/email_customer_survery_week_1.log 2>&1\n\n# Scan order shipping log to send shipping confirmation email\n*/30 * * * * /usr/bin/php /src/haute/batch/encidate_shipping_update.php >> /var/log/haute/encidate_shipping_update.log 2>&1\n\n# In Bag Daily reminder\n0 * * * * /usr/bin/php /src/haute/batch/email_items_in_bag.php >> /var/log/haute/email_items_in_bag.log 2>&1\n\n#* * * * * /usr/bin/php /src/haute/batch/email_test.php >> /var/log/haute/test.log 2>&1' | crontab\" www-data"
