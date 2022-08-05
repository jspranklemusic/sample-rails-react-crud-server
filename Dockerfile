FROM ruby:3.1.2
EXPOSE 3000

# Default directory
ENV INSTALL_PATH /opt/app
RUN mkdir -p $INSTALL_PATH
ADD . $INSTALL_PATH

# Install rails
WORKDIR $INSTALL_PATH
RUN gem install rails bundler
RUN bundle install
RUN rails db:migrate 

ENTRYPOINT [ "rails", "s", "-b", "0.0.0.0" ]