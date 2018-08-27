# README

## Installing requirements.

```bash
sudo apt-get -y  install imagemagick redis-server redis-tools nginx passenger
```

## Rake tasks

### Removing users

The following task removes an account.

```
$ rake insitu:drop_user[user@domain.com]
```

### Statistics

The following task extracts usage statistics.

```
$rake insitu:statistics
```

## Deploy

### First time setup

```
$ cap production setup:copy_sidekiq_yml
$ cap production setup
```

### Regular process

```
$ cap production deploy
```

Additionally the rails user must have a .bash_profile that loads the rbenv environment.

```
rails@billing:~$ cat .bash_profile
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
```

### Setup sidekiq
Create the sidekiq script in /etc/init.d with the following contents:

```
#!/bin/bash
# sidekiq    Init script for Sidekiq
# chkconfig: 345 100 75
#
# Description: Starts and Stops Sidekiq message processor for Stratus application.
#
# User-specified exit parameters used in this script:
#
# Exit Code 5 - Incorrect User ID
# Exit Code 6 - Directory not found


# You will need to modify these
APP="insitu"
AS_USER="rails"
APP_DIR="/opt/${APP}/current"

APP_CONFIG="${APP_DIR}/config"
LOG_FILE="$APP_DIR/log/sidekiq.log"
LOCK_FILE="$APP_DIR/tmp/${APP}-lock"
PID_FILE="$APP_DIR/tmp/pids/sidekiq.pid"
GEMFILE="$APP_DIR/Gemfile"
SIDEKIQ="sidekiq"
APP_ENV="production"
BUNDLE="bundle"

START_CMD="$BUNDLE exec $SIDEKIQ -e $APP_ENV -P $PID_FILE"
CMD="cd ${APP_DIR}; ${START_CMD} >> ${LOG_FILE}  &"

RETVAL=0


start() {

  status
  if [ $? -eq 1 ]; then

    [ `id -u` == '0' ] || (echo "$SIDEKIQ runs as root only .."; exit 5)
    [ -d $APP_DIR ] || (echo "$APP_DIR not found!.. Exiting"; exit 6)
    cd $APP_DIR
    echo "Starting $SIDEKIQ message processor .. "

    su -c "$CMD" - $AS_USER

    RETVAL=$?
    #Sleeping for 8 seconds for process to be precisely visible in process table - See status ()
        sleep 8
        [ $RETVAL -eq 0 ] && touch $LOCK_FILE
        return $RETVAL
      else
        echo "$SIDEKIQ message processor is already running .. "
      fi
    
    
    }
    
    stop() {
    
        echo "Stopping $SIDEKIQ message processor .."
        SIG="INT"
        kill -$SIG `cat  $PID_FILE`
        RETVAL=$?
        [ $RETVAL -eq 0 ] && rm -f $LOCK_FILE
        return $RETVAL
    }
    
    status() {
        ps -ef | grep 'sidekiq [0-9].[0-9].[0-9]' | grep -v grep
        return $?
    }
    
    
    case "$1" in
        start)
            start
            ;;
        stop)
            stop
            ;;
    
        restart)
            stop
            start
            ;;
        status)
            status
            if [ $? -eq 0 ]; then
                echo "$SIDEKIQ message processor is running .."
                RETVAL=0
            else
                echo "$SIDEKIQ message processor is stopped .."
                RETVAL=1
            fi
            ;;
        *)
            echo "Usage: $0 {start|stop|restart|status}"
            exit 0
            ;;
    esac
    exit $RETVAL
```

and enable sidekiq on start

```
# sudo update-rc.d sidekiq defaults 99
```

In order to manually execute sidekiq

```
rails@billing:/opt/insitu/current$ bundle exec sidekiq -d -l log/sidekiq.log -C config/sidekiq.yml -e production
```


rails@billing:/opt/insitu/current$ redis-cli
127.0.0.1:6379> select 0
OK
127.0.0.1:6379> keys *
1) "queue:mailer"
2) "billing.insitu.tools:14137"
3) "queues"
4) "processes"
127.0.0.1:6379> smembers queues
1) "mailer"
127.0.0.1:6379> lrange queue:mailer 0 -1
1) "{\"retry\":true,\"queue\":\"mailer\",\"class\":\"Devise::Async::Backend::Sidekiq\",\"args\":[\"confirmation_instructions\",\"User\",\"3\",\"ynjZ1qSYP5ZjuUBq4Vb3\",{\"to\":\"billing@insitu.tools\",\"locale\":\"en\"}],\"jid\":\"a4ecb4f855f062a58be09f44\",\"enqueued_at\":1464031514.381195,\"apartment\":\"fges_production\"}"
2) "{\"retry\":true,\"queue\":\"mailer\",\"class\":\"Devise::Async::Backend::Sidekiq\",\"args\":[\"confirmation_instructions\",\"User\",\"3\",\"ynjZ1qSYP5ZjuUBq4Vb3\",{\"to\":\"billing@insitu.tools\",\"locale\":\"en\"}],\"jid\":\"a14a182ca1c2665048b2ee29\",\"enqueued_at\":1464030503.598324,\"apartment\":\"fges_production\"}"
