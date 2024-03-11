FROM ruby:2.6.10

# Required packages
RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install -y build-essential default-mysql-client default-libmysqlclient-dev imagemagick nodejs libmagickwand-dev sudo unzip vim apt-utils && \
    apt-get clean

# Test requirements
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install -y google-chrome-stable \
  && apt-get clean

RUN CHROMEDRIVER_RELEASE=2.41 \
  && CHROMEDRIVER_URL="http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_RELEASE/chromedriver_linux64.zip" \
  && apt-get install unzip \
  && curl --silent --show-error --location --fail --retry 3 --output /tmp/chromedriver_linux64.zip $CHROMEDRIVER_URL \
  && unzip /tmp/chromedriver_linux64.zip chromedriver -d /usr/local/share \
  && chmod +x /usr/local/share/chromedriver \
  && ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver \
  && rm /tmp/chromedriver_linux64.zip

# Define where our application will live inside the image
ENV RAILS_ROOT /insitu

RUN mkdir -p $RAILS_ROOT/tmp/pids

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

WORKDIR $RAILS_ROOT

ADD Gemfile $RAILS_ROOT/Gemfile
ADD Gemfile.lock $RAILS_ROOT/Gemfile.lock

RUN chown -R insitu:insitu $RAILS_ROOT

USER insitu

# Bundle configuration
RUN gem install bundler

ENV BUNDLE_JOBS=4
RUN bundle install

ADD . $RAILS_ROOT
