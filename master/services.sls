# Ensure salt services are enabled and running
salt_master_running:
  service.running:
    - name: salt-master
    - enable: True

salt_minion_running:
  service.running:
    - name: salt-minion
    - enable: True
