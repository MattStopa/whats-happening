FROM ruby:2.5
RUN apt-get update -qq 

# Installs node 13 (current latest)
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get install -y nodejs

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY ./* /myapp/

RUN gem install bundler
RUN bundle install

COPY ./ /myapp

# Install Yarn 
RUN npm install -g yarn
RUN yarn

# Make the container run at the user level
RUN chgrp -R 0 /myapp && \
    chmod -R g=u /myapp 

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
EXPOSE 8080



# Start the main process.
# CMD ["rails", "server", "-b", "0.0.0.0"]