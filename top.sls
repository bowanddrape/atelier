#https://docs.saltstack.com/en/latest/ref/states/top.html

#This file contains a mapping between groups of
#machines on a network and the configuration roles
#that should be applied to them

#Top files have three components:

#--Environment--
#    A state tree directory containing a set of state files
#    to configure systems.
#--Target--
#    A grouping of machines which will have a set of states
#    applied to them.
#--State Files--
#    A list of state files to apply to a target.
#    Each state file describes one or more states to be configured
#    and enforced on the targeted machines.

#--Format--
# enviroment_name:     (base is salt default)
#   'id':              (your minion_id goes here. '*' for all)
#   - match: compound  (use compound matching for finding minion_ids)
#   - state_file       (sls file to execute)


base:
  '*':
   - match: compound
   - global

  'G@roles:couture':
   - match: compound
   - couture

  'G@roles:couture-db':
   - match: compound
   - couture.db-master

  'G@roles:haute':
   - match: compound
   - haute

  'G@roles:haute-cron':
   - match: compound
   - haute.cron

