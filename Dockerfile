FROM ruby:2.4.2

# Required packages
RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install -y build-essential mysql-client libmysqlclient-dev nodejs sudo imagemagick libmagickwand-dev  && \
    apt-get clean

# Define where our application will live inside the image
ENV APP_HOME /opt/insitu/current

# Bundler setup
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_JOBS=4 \
    BUNDLE_PATH=/bundle

###### USER CREATION #########
# Change the Group ID and User ID with your local Group and user id
ENV USER_NAME insitu
ENV USER_ID 1000
ENV GROUP_ID 1000
ENV USER_HOME /home/$USER_NAME
RUN groupadd $USER_NAME -g $GROUP_ID && \
    useradd $USER_NAME -d $USER_HOME -m -s /bin/bash --uid $USER_ID --gid $GROUP_ID && \
    adduser $USER_NAME sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR $APP_HOME

ADD Gemfile $APP_HOME/Gemfile

RUN mkdir -p $APP_HOME
RUN chown -R $USER_NAME:$USER_NAME $APP_HOME

RUN mkdir -p $BUNDLE_PATH
RUN chown -R $USER_NAME:$USER_NAME $BUNDLE_PATH

USER $USER_NAME

# Bundle configuration
RUN gem install bundler

RUN bundle check || bundle install

ADD . $RAILS_ROOT
