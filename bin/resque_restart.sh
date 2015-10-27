kill  `cat /home/hxh/share/ruby/newjq/tmp/pids/resque.pid`
kill  `cat /home/hxh/share/ruby/newjq/tmp/pids/scheduler.pid`
rake environment resque:scheduler PIDFILE='tmp/pids/scheduler.pid' BACKGROUND=yes
TERM_CHILD=1 QUEUE=* rake environment resque:work PIDFILE='tmp/pids/resque.pid' BACKGROUND=yes

