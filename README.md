<a id="readme-top"></a>

<br />
<div align="center">
  <a href="https://github.com/victoralvesf/aonsoku-podcasts">
    <img src="https://cdn.jsdelivr.net/gh/victoralvesf/aonsoku@main/public/favicons/android-chrome-192x192.png" alt="Aonsoku" width="80" height="80">
  </a>

  <h3 align="center">Aonsoku Podcasts</h3>
  <p align="center">
    An API designed to provide podcast support for the Aonsoku app.
    <br />
    <br />
    <a href="https://github.com/victoralvesf/aonsoku-podcasts/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/victoralvesf/aonsoku-podcasts/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>

  [![Laravel][Laravel]][Laravel-url] [![PHP][PHP]][PHP-url]
  
  [![API Docs][Docs-badge]][Docs-url] [![Docker Images][Docker-Images-badge]][Docker-Images-url]
</div>

<!-- TABLE OF CONTENTS -->
## Table of contents

<ol>
  <li>
    <a href="#api-documentation">API Documentation</a>
  </li>
  <li>
    <a href="#getting-started">Getting Started</a>
    <ul>
      <li><a href="#prerequisites">Prerequisites</a></li>
      <li><a href="#installation">Installation</a></li>
      <li><a href="#running">Running</a></li>
      <li><a href="#environment-variables">Environment Variables</a></li>
      <li><a href="#portainer">Deployment with Portainer</a></li>
    </ul>
  </li>
  <li><a href="#contributing">Contributing</a></li>
  <li><a href="#license">License</a></li>
</ol>

## API Documentation

For detailed information on how to use the Aonsoku Podcasts API, please refer to the [API Documentation][Docs-url].

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Getting Started

### Prerequisites

* PHP 8.2 or greater
* Composer
* Laravel

### Installation

1. Clone the repo:
```sh
git clone https://github.com/victoralvesf/aonsoku-podcasts.git
```
2. Install dependencies:
```sh
composer install
```
3. Copy the environment file:
```sh
cp .env.example .env
```
4. Edit database config, if you don't want to use `sqlite`:
```dotenv
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=YourDatabaseName
DB_USERNAME=YourUsername
DB_PASSWORD=YourPassword
```
5. Generate application key:
```sh
php artisan key:generate
```
6. Run database migrations:
```sh
php artisan migrate
```
7. Start the server:
```sh
php artisan serve
```

> [!TIP]
>
> If you have `node.js` installed, you can run: 
>
> ```
> composer dev
> ```
>
> This will run the server, queue, scheduler and logs in parallel.

8. Starting the queue and schedule separated:
```sh
# queue
php artisan queue:listen

# schedule
php artisan schedule:work
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Running

To deploy the Aonsoku Podcasts API using Docker Compose:

1. Clone the repo:

```sh
git clone https://github.com/victoralvesf/aonsoku-podcasts.git
```

2. Copy the environment file:
```sh
cp .env.example .env.production
```

3. Update the environment file as you need.

> [!CAUTION]
>
> Ensure to fill the database settings. Example:
>
> ```dotenv
> DB_CONNECTION=mysql
> DB_HOST=mysql # needs to be mysql to work with docker compose.
> DB_PORT=3306
> DB_DATABASE=YourDatabaseName
> DB_USERNAME=YourUsername
> DB_PASSWORD=YourPassword
> DB_ROOT_PASSWORD=YourRootUserPassword
>
> # Make sure to set this to mysql aswell
> DB_QUEUE_CONNECTION=mysql
> ```
>
> Additionally, generate a key for your `.env.production` file:
>
> If you don't have access to any Laravel project, you can obtain a random key on this page:
>
> https://laravel-encryption-key-generator.vercel.app/
> 
> Thanks to [Stefan Zweifel](https://github.com/stefanzweifel) for this helpful tool!

4. Start with Docker Compose
```sh
docker compose --env-file .env.production up -d
```

### Environment Variables

- Refer to the `.env.example` file for a clearer understanding of the settings.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<div id="portainer"></div>

### Deployment with Portainer

1. Stack configuration (YAML):

```yaml
services:
    app:
        image: ghcr.io/victoralvesf/aonsoku-podcasts:latest
        container_name: aonsoku_podcasts
        environment:
            - CONTAINER_ROLE=app
        ports:
            - "6060:8080"
        depends_on:
            mysql:
                condition: service_healthy

    mysql:
        image: mysql:8
        container_name: aonsoku_podcasts_db
        environment:
            - MYSQL_DATABASE=${DB_DATABASE}
            - MYSQL_USER=${DB_USERNAME}
            - MYSQL_PASSWORD=${DB_PASSWORD}
            - MYSQL_ROOT_PASSWORD=${DB_ROOT_PASSWORD}
        volumes:
            - mysql_data:/var/lib/mysql
        healthcheck:
            test: [ "CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "--silent" ]
            interval: 5s
            timeout: 3s
            retries: 5
            start_period: 0s

    queue:
        image: ghcr.io/victoralvesf/aonsoku-podcasts:latest
        container_name: aonsoku_podcasts_queue
        environment:
            - CONTAINER_ROLE=worker
            - PHP_MEMORY_LIMIT=512M
        stop_signal: SIGTERM
        depends_on:
            - app
        healthcheck:
            test: [ "CMD", "healthcheck-queue" ]
            start_period: 10s

    scheduler:
        image: ghcr.io/victoralvesf/aonsoku-podcasts:latest
        container_name: aonsoku_podcasts_scheduler
        environment:
            - CONTAINER_ROLE=scheduler
        stop_signal: SIGTERM
        depends_on:
            - app
        healthcheck:
            test: [ "CMD", "healthcheck-schedule" ]
            start_period: 10s

volumes:
    mysql_data:
```

2. Environment Variables

Scroll down to the Environment variables section in Portainer. Add the following variables.

- **Critical Database Settings:** These allow the application to connect to the MySQL service defined in the stack.

| Name              | Value                           |
|-------------------|---------------------------------|
| DB_CONNECTION     | mysql                           |
| DB_HOST           | mysql                           |
| DB_PORT           | 3306                            |
| DB_DATABASE       | aonsoku_podcasts                |
| DB_USERNAME       | aonsoku_user                    |
| DB_PASSWORD       | (Enter a secure password)       |
| DB_ROOT_PASSWORD  | (Enter a secure root password)  |

- **Application Settings:**

| Name          | Value                                                      |
|---------------|------------------------------------------------------------|
| APP_NAME      | AonsokuPodcasts                                            |
| APP_ENV       | production                                                 |
| APP_KEY       | (Generate one locally or using the tool mentioned above )  |
| APP_DEBUG     | false                                                      |
| APP_URL       | http://your-local-domain.com                               |
| APP_TIMEZONE  | Your Timezone e.g. `Europe/Berlin`                           |

- **Queue & Cache Settings:**

| Name                 | Value     |
|----------------------|-----------|
| QUEUE_CONNECTION     | database  |
| DB_QUEUE_CONNECTION  | mysql     |
| CACHE_STORE          | database  |
| SESSION_DRIVER       | database  |
| SESSION_LIFETIME     | 120       |

3. Deploy the stack.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[Docs-badge]: https://img.shields.io/badge/API%20Documentation-000000?style=for-the-badge&logo=read-the-docs&logoSize=auto
[Docs-url]: https://app.theneo.io/aonsoku/podcasts

[Laravel]: https://img.shields.io/badge/Laravel-000000?style=for-the-badge&logo=laravel&logoSize=auto
[Laravel-url]: https://laravel.com/

[PHP]: https://img.shields.io/badge/PHP-000000?style=for-the-badge&logo=php&logoSize=auto
[PHP-url]: https://www.php.net/

[Docker-Images-badge]: https://img.shields.io/badge/Docker%20Images-000000?style=for-the-badge&logo=docker&logoSize=auto
[Docker-Images-url]: https://github.com/victoralvesf/aonsoku-podcasts/pkgs/container/aonsoku-podcasts
