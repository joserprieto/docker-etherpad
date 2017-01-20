# What is Etherpad?

Etherpad is a really-real time collaborative editor maintained by the Etherpad Community.

Etherpad is written in JavaScript (99.9%) on both the server and client so it's easy for developers to maintain and add new features.  Because of this Etherpad has tons of customizations that you can leverage.

Etherpad is designed to be easily embeddable and provides a [HTTP API](https://github.com/ether/etherpad-lite/wiki/HTTP-API)
that allows your web application to manage pads, users and groups. It is recommended to use the [available client implementations](https://github.com/ether/etherpad-lite/wiki/HTTP-API-client-libraries) in order to interact with this API.

There is also a [jQuery plugin](https://github.com/ether/etherpad-lite-jquery-plugin) that helps you to embed Pads into your website.

There's also a full-featured plugin framework, allowing you to easily add your own features.  By default your Etherpad is rather sparse and because Etherpad takes a lot of it's inspiration from Wordpress plugins are really easy to install and update.  Once you have Etherpad installed you should visit the plugin page and take control.

Finally, Etherpad comes with translations into most languages!  Users are automatically delivered the correct language for their local settings.


**Visit [beta.etherpad.org](http://beta.etherpad.org) to test it live.**

Also, check out the **[FAQ](https://github.com/ether/etherpad-lite/wiki/FAQ)**, really!

<!--%%LOGO%%-->
![logo](./logo.png)

# About this image

Docker image for Etherpad Lite collaborative text editor, with support for locale and timezone, before build the image.

But add extra support for configure timezone and locales before built the image, with the arguments in 
the `docker build` command (`--build-arg`), and `ARG` in the `Dockerfile`.

Default values for the timezone and locale are:

```bash
Timezone:   "Europe/Madrid"
Locale:     es_ES.UTF-8
```


# How to use this Image.

## Build a localized image.

To build a localized image, this is, a PostgreSQL (Debian based) Image with locale and timezone correctly defined, we
have to use the `--build-arg` parameter of the `docker build` command.

An example:

```bash
docker build --build-arg TIMEZONE="Europe/France" --build-arg LOCALE_LANG_COUNTRY="fr_FR" .
```

## Locales

The locales are generated with the snippet described in Debian Official Image, and
[used in PostgreSQL Official Image](https://github.com/docker-library/postgres/blob/69bc540ecfffecce72d49fa7e4a46680350037f9/9.6/Dockerfile#L21-L24):

```dockerfile
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
```

We only add a few arguments for the build:

```dockerfile
ARG LOCALE_LANG_COUNTRY="es_ES"
ARG LOCALE_CODIFICATION="UTF-8"
ARG LOCALE_CODIFICATION_ENV="utf8"
```

And execute the build as:


```dockerfile
    && echo "=> Configuring and installing locale (${LOCALE_LANG_COUNTRY}.${LOCALE_CODIFICATION}):" \
    && apt-get install -y locales \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i ${LOCALE_LANG_COUNTRY} -c -f ${LOCALE_CODIFICATION} -A /usr/share/locale/locale.alias ${LOCALE_LANG_COUNTRY}.${LOCALE_CODIFICATION} \
```

## Timezone

We use a snippet provided by [Oscar](https://oscarmlage.com/) (Thanks!):

```dockerfile
    echo "=> Configuring and installing timezone:" && \
        echo "Europe/Madrid" > /etc/timezone && \
        dpkg-reconfigure -f noninteractive tzdata && \
```

Only added an ARG for the build:

```dockerfile
ARG TIMEZONE="Europe/Madrid"
```

And, finally:

```dockerfile
    && echo "=> Configuring and installing timezone (${TIMEZONE}):" \
    && echo ${TIMEZONE} > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
```

Obviously, the value of the timezone has to be one of the right values:

[Change Timezone on Debian](https://wiki.debian.org/TimeZoneChanges)
[List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)


## start a Etherpad instance

```console
$ docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
```

This image includes `EXPOSE 5432` (the postgres port), so standard container linking will make it automatically available to the linked containers. The default `postgres` user and database are created in the entrypoint with `initdb`.

> The postgres database is a default database meant for use by users, utilities and third party applications.
> [postgresql.org/docs](http://www.postgresql.org/docs/9.5/interactive/app-initdb.html)


## Environment Variables


### `ETHERPAD_PASSWORD`

This environment variable is recommended for you to use the PostgreSQL image. This environment variable sets the superuser password for PostgreSQL. The default superuser is defined by the `POSTGRES_USER` environment variable. In the above example, it is being set to "mysecretpassword".


# How to extend this image
